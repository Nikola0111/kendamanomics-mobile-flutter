import 'package:pay/pay.dart';

class PayService {
  Pay? payClient;

  PayService() {
    _initClient();
  }

  void _initClient() {
    payClient = Pay({
      PayProvider.google_pay: PaymentConfiguration.fromJsonString(_defaultGooglePay),
      PayProvider.apple_pay: PaymentConfiguration.fromJsonString(_defaultApplePay),
    });
  }

  // Future<void> _isApplePayInstalled() async {
  //   _applePayAvailability = await _payClient!.userCanPay(PayProvider.apple_pay);
  //   if (_applePayAvailability) {
  //     //consider swapping to bool and then calling apyclien.showpaymentselector, check out future builder from docs aswell
  //     notifyListeners();
  //   } else {
  //     logE('Apple pay is not available');
  //   }
  // }
  //
  // Future<void> _isGooglePayInstalled() async {
  //   _googlePayAvailability = await _payClient!.userCanPay(PayProvider.google_pay);
  //   if (_googlePayAvailability) {
  //     notifyListeners();
  //   } else {
  //     logE('Google pay is not available');
  //   }
  // }
}

const _defaultApplePay = '''{
  "provider": "apple_pay",
  "data": {
    "merchantIdentifier": "merchant.com.kendamanomics.app",
    "displayName": "Kendamanomics",
    "merchantCapabilities": ["3DS", "debit", "credit"],
    "supportedNetworks": ["amex", "visa", "discover", "masterCard"],
    "countryCode": "US",
    "currencyCode": "USD",
    "requiredBillingContactFields": [],
    "requiredShippingContactFields": [],
    "shippingMethods": []
  }
}''';

const _defaultGooglePay = '''{
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
          "gateway": "stripe",
          "stripe:version": "2023-10-16"
          "stripe:publishableKey": "YOUR_PUBLIC_STRIPE_KEY"
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
      "merchantId": "BCR2DN4T3GX65XAM",
      "merchantName": "Lotus Kendamas"
    },
    "transactionInfo": {
      "countryCode": "US",
      "currencyCode": "USD"
    }
  }
}''';
