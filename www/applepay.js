var ApplePay = {

    getAllowsApplePay: function(successCallback, errorCallback) {
        cordova.exec(
            successCallback,
            errorCallback,
            'ApplePay',
            'getAllowsApplePay',
            []
        );
    },
    
    setStripePublishableKey: function(publishableKey, successCallback, errorCallback) {
        cordova.exec(
            successCallback,
            errorCallback,
            'ApplePay',
            'setStripePublishableKey',
            [publishableKey]
        );
    },
	
    setMerchantId: function(merchantId, successCallback, errorCallback) {
        cordova.exec(
            successCallback,
            errorCallback,
            'ApplePay',
            'setMerchantId',
            [merchantId]
        );
    },

    getStripeToken: function(amount, name, currency, successCallback, errorCallback) {
        cordova.exec(
            successCallback,
            errorCallback,
            'ApplePay',
            'getStripeToken',
            [amount, name, currency]
        );
    }
    
};

module.exports = ApplePay;
