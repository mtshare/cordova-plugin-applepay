#import "CDVApplePay.h"


@implementation CDVApplePay

- (void) pluginInitialize {
    [super pluginInitialize];
    
#ifdef DEBUG
    NSLog(@"Initialize Apple Pay Plugin");
#endif
    
    publishableKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"StripePublishableKey"];
    if ([publishableKey length]) {
        [Stripe setDefaultPublishableKey:publishableKey];
    }
    merchantId = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"ApplePayMerchant"];
}



/*
 * Set Stripe Publishable Key via Javascript
 */
- (void)setStripePublishableKey:(CDVInvokedUrlCommand*)command
{
    publishableKey = [command.arguments objectAtIndex:0];
    [Stripe setDefaultPublishableKey:publishableKey];
    
#ifdef DEBUG
    NSLog(@"ApplePay set Stripe publishable key %@", publishableKey);
#endif
}



- (void)setMerchantId:(CDVInvokedUrlCommand*)command
{
    merchantId = [command.arguments objectAtIndex:0];
    
#ifdef DEBUG
    NSLog(@"ApplePay set merchant id to %@", merchantId);
#endif
}




- (void)getAllowsApplePay:(CDVInvokedUrlCommand*)command
{
    if (merchantId == nil) {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                    messageAsString:@"Please call setMerchantId() with your Apple-given merchant ID."];
        return [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }
    
    if ([PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:@[PKPaymentNetworkMasterCard, PKPaymentNetworkVisa, PKPaymentNetworkPrivateLabel]]) {
        //  Pay is available!
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                    messageAsString:@"User has Apple Pay"];
        [self.commandDelegate sendPluginResult:result
                                    callbackId:command.callbackId];
    } else {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                    messageAsString:@"User does not have Apple Pay"];
        [self.commandDelegate sendPluginResult:result
                                    callbackId:command.callbackId];
    }
}





- (void)getStripeToken:(CDVInvokedUrlCommand*)command
{
    if (merchantId == nil) {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                    messageAsString:@"Please call setMerchantId() with your Apple-given merchant ID."];
        return [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }
    
    NSString *countryCode = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    NSDictionary *arguments = [command.arguments objectAtIndex:0];
    
    PKPaymentRequest *paymentRequest = [Stripe paymentRequestWithMerchantIdentifier:merchantId];
    paymentRequest.merchantCapabilities = PKMerchantCapability3DS;
    paymentRequest.supportedNetworks = @[PKPaymentNetworkMasterCard, PKPaymentNetworkVisa, PKPaymentNetworkPrivateLabel];
    paymentRequest.countryCode = countryCode;
    paymentRequest.currencyCode = arguments[@"currency"];
    
    // Configure your request here.
    NSString *amountString = [NSString stringWithFormat:@"%.02f", [arguments[@"amount"] floatValue]];
    NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithString:amountString];
    paymentRequest.paymentSummaryItems = @[
                                           [PKPaymentSummaryItem summaryItemWithLabel:arguments[@"description"] amount:amount]
                                           ];
    
    callbackId = command.callbackId;
    
    if ([Stripe canSubmitPaymentRequest:paymentRequest]) {
        PKPaymentAuthorizationViewController *paymentController = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:paymentRequest];
        paymentController.delegate = self;
        [self.viewController presentViewController:paymentController animated:YES completion:nil];
    } else {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                    messageAsString:@"You dont have access to ApplePay"];
        [self.commandDelegate sendPluginResult:result
                                    callbackId:command.callbackId];
    }
}



- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus))completion
{
    [[STPAPIClient sharedClient] createTokenWithPayment:payment
                                             completion:^(STPToken *token, NSError *error) {
                                                 if (error) {
                                                     
                                                     completion(PKPaymentAuthorizationStatusFailure);
                                                     CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                                                                 messageAsString:@"couldn't get a stripe token from STPAPIClient"];
                                                     [self.commandDelegate sendPluginResult:result
                                                                                 callbackId:callbackId];
                                                     
                                                 } else {
                                                     
                                                     NSString* brand;
                                                     
                                                     switch (token.card.brand) {
                                                         case STPCardBrandVisa:
                                                             brand = @"Visa";
                                                             break;
                                                         case STPCardBrandAmex:
                                                             brand = @"American Express";
                                                             break;
                                                         case STPCardBrandMasterCard:
                                                             brand = @"MasterCard";
                                                             break;
                                                         case STPCardBrandDiscover:
                                                             brand = @"Discover";
                                                             break;
                                                         case STPCardBrandJCB:
                                                             brand = @"JCB";
                                                             break;
                                                         case STPCardBrandDinersClub:
                                                             brand = @"Diners Club";
                                                             break;
                                                         case STPCardBrandUnknown:
                                                             brand = @"Unknown";
                                                             break;
                                                     }
                                                     
                                                     NSDictionary* card = @{
                                                                            @"id": token.card.cardId,
                                                                            @"brand": brand,
                                                                            @"last4": [NSString stringWithFormat:@"%@", token.card.last4],
                                                                            @"exp_month": [NSString stringWithFormat:@"%lu", token.card.expMonth],
                                                                            @"exp_year": [NSString stringWithFormat:@"%lu", token.card.expYear]
                                                                            };
                                                     
                                                     NSDictionary* message = @{
                                                                               @"id": token.tokenId,
                                                                               @"card": card
                                                                               };
                                                     
                                                     completion(PKPaymentAuthorizationStatusSuccess);
                                                     
                                                     CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                                                             messageAsDictionary:message];
                                                     [self.commandDelegate sendPluginResult:result
                                                                                 callbackId:callbackId];
                                                 }
                                             }];
}



- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                messageAsString:@"user cancelled apple pay"];
    [self.commandDelegate sendPluginResult:result
                                callbackId:callbackId];
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}



@end
