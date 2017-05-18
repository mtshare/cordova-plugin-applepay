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

- (void)setMerchantId:(CDVInvokedUrlCommand*)command;
- (void)getAllowsApplePay:(CDVInvokedUrlCommand*)command;
- (void)getStripeToken:(CDVInvokedUrlCommand*)command;

@end
