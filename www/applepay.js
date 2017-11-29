

var exec = require('cordova/exec');


/**
 * Provides access to Apple Pay on iOS devices.
 */

module.exports = {

    /**
     * Check if Apple Pay is available
     */
    getAllowsApplePay: function (successCallback, errorCallback) {
        exec(successCallback, errorCallback, 'ApplePay', 'getAllowsApplePay', []);
    },
    

    /**
     * Setting Stripe publishable key
     * @param {string} publishableKey  Stripe Publishable Key
     */
    setStripePublishableKey: function (publishableKey, successCallback, errorCallback) {
        exec(successCallback, errorCallback, 'ApplePay', 'setStripePublishableKey', [publishableKey]);
    },

    
    /**
     * Set Apple Marchant ID
     * @param {string} merchantId      Apple merchant ID
     */
    setMerchantId: function (merchantId, successCallback, errorCallback) {
        exec(successCallback, errorCallback, 'ApplePay', 'setMerchantId', [merchantId]);
    },


    /**
     * Retrive Stripe token
     * @param  {object} infos
     * {
     *     • amount
     *     • description
     *     • currency EUR | USD
     * }
     */
    getStripeToken: function (infos, successCallback, errorCallback) {
        // Check mandatory elements
        if (typeof infos === 'undefined' || infos.amount === 'undefined') return false;
        if (typeof infos.description === 'undefined') infos.description = 'ApplePay Payment';
        if (typeof infos.currency === 'undefined') infos.currency = 'EUR';
        exec(successCallback, errorCallback, 'ApplePay', 'getStripeToken', [infos]);
    }

};