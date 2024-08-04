import 'dart:developer';

import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayFunctions {
  late Razorpay razorpay;
  RazorpayFunctions({
    required Function(PaymentSuccessResponse) onSuccess,
    required Function(PaymentFailureResponse) onFailure,
  }) {
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
        (PaymentSuccessResponse response) async {

      await onSuccess(response);
      
      razorpay.clear();
    });
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
        (PaymentFailureResponse response) async {
      await onFailure(response);
      razorpay.clear();
    });
  }

  void initiatePayment(String email, String songName) {
    var options = {
      'key': 'rzp_test_AvT5kBOLiXnX5i',
      'amount': 100000,
      'name': songName,
      'description': 'Sound of Meme',
      'prefill': {'email': email}
    };
    try {
      razorpay.open(options);
    } catch (e) {
      log('Error: $e');
    }
  }

  
}
