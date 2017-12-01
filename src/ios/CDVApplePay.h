#import <UIKit/UIKit.h>
#import <Cordova/CDVPlugin.h>
#import <PassKit/PassKit.h>
#import <Stripe/Stripe.h>
#import <objc/runtime.h>


@interface CDVApplePay : CDVPlugin <PKPaymentAuthorizationViewControllerDelegate>
{
    NSString *merchantId;
    NSString *publishableKey;
    NSString *callbackId;
}

/**
 * Set Apple merchant ID
 */
- (void)setMerchantId:(CDVInvokedUrlCommand*)command;


/**
 * Open payment setup
 */
-(void)openPaymentSetup:(CDVInvokedUrlCommand*)command;


/**
 * Check if Apple Pay is available
 */
- (void)getAllowsApplePay:(CDVInvokedUrlCommand*)command;


/**
 * Retrive Stripe Token
 */
- (void)getStripeToken:(CDVInvokedUrlCommand*)command;

@end
