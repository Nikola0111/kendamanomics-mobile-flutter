const String defaultApplePay = '''{
  "provider": "apple_pay",
  "data": {
    "merchantIdentifier": "merchant.com.domain.project",
    "displayName": "App name",
    "merchantCapabilities": ["3DS", "debit", "credit"],
    "supportedNetworks": ["amex", "visa", "discover", "masterCard"],
    "countryCode": "QA",
    "currencyCode": "QAR",
    "requiredBillingContactFields": [],
    "requiredShippingContactFields": [],
    "shippingMethods": []
  }
}''';

const String defaultGooglePay = '''{
  "provider": "google_pay",
  "data": {
    "environment": "TEST",
    "apiVersion": 2,
    "apiVersionMinor": 0,
    "allowedPaymentMethods": [{
      "type": "CARD",
      "tokenizationSpecification": {
        "type": "PAYMENT_GATEWAY",
        "parameters": {
          "gateway": "example",
          "gatewayMerchantId": "gatewayMerchantId"
        }
      },
      "parameters": {
        "allowedCardNetworks": ["VISA", "MASTERCARD"],
        "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
        "billingAddressRequired": true,
        "billingAddressParameters": {
          "format": "FULL",
          "phoneNumberRequired": true
        }
      }
    }],
    "merchantInfo": {
      "merchantId": "01234567890123456789",
      "merchantName": "Example Merchant Name"
    },
    "transactionInfo": {
      "countryCode": "QA",
      "currencyCode": "QAR"
    }
  }
}''';
