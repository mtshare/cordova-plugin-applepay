# cordova-plugin-applepay

This plugin is a basic implementation of Stripe and Apple Pay with the purpose of returning a useable stripe token.


## Installation

1. Follow the steps on https://stripe.com/docs/mobile/apple-pay to get your certs generated
2. In your Xcode project, go to **Capabilities** and enable **Apple Pay**
3. Install the plugin
```sh
cordova plugin add https://github.com/mtshare/cordova-plugin-applepay
```

## Supported Platforms

- iOS

## Methods

- ApplePay.getAllowsApplePay
- ApplePay.setMerchantId
- ApplePay.setStripePublishableKey
- ApplePay.getStripeToken

#### ApplePay.getAllowsApplePay

Returns successfully if the device is setup for Apple Pay (correct software version, correct hardware & has card added).

```js
ApplePay.getAllowsApplePay(successCallback, errorCallback);
```

#### ApplePay.setMerchantId

Set your Apple-given merchant ID. This overrides the value obtained from **ApplePayMerchant** in **Info.plist**.

```js
ApplePay.setMerchantId('merchant.apple.test', successCallback, errorCallback);
```

#### ApplePay.setStripePublishableKey

Set your Stripe Publishable Key. This overrides the value obtained from **StripePublishableKey** in **Info.plist**.

```js
ApplePay.setStripePublishableKey('pk_test_stripekey', successCallback, errorCallback);
```

#### ApplePay.getStripeToken

Request a stripe token for an Apple Pay card. 
- amount (string)
- description (string)
- currency (uppercase string)

```js
ApplePay.getStripeToken(amount, description, currency, successCallback, errorCallback);
```

##### Response
```json
{
	"id": "tok_STRIPE_TOKEN",
	"card": {
		"id": "card_CARD_ID",
		"brand": "MasterCard",
		"last4": "1234",
		"exp_year": "2050",
		"exp_month": "6"
	}
}
```

## Example

```js
ApplePay.setMerchantId('merchant.apple.test');

ApplePay.getAllowsApplePay(function() {

	ApplePay.getStripeToken({
		amount: '10.00',
		description:  'Delicious Cake',
		currency: 'USD'
	}, function(results) {
		alert('Your token is: ' + results.id);
	}, function() {
		alert('Error getting payment info');
	});

}, function() {
	alert('User does not have apple pay available');
});

```