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

    getStripeToken: function(infos, successCallback, errorCallback) {
        if(typeof infos === 'undefined' || infos.amount === 'undefined') return false;

        if (infos.description === 'undefined') infos.description = 'ApplePay Payment';
        if (infos.currency === 'undefined') infos.currency = 'EUR';

        cordova.exec(
            successCallback,
            errorCallback,
            'ApplePay',
            'getStripeToken',
            [infos.amount, infos.description, infos.currency]
        );
    }
    
};

module.exports = ApplePay;
