import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import './api_services.dart';
import 'api_services.dart';

class RazorPayIntegration {
  final Razorpay _razorpay = Razorpay(); //Instance of razor pay
  final razorPayKey = "rzp_test_RDsdaax6UE4Dlk";
  final razorPaySecret = "BA4UgUCtVEmV1wImHL0h2vTr";
  intiateRazorPay() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // Do something when payment succeeds
    User? user = FirebaseAuth.instance.currentUser;
    //
    CollectionReference users = FirebaseFirestore.instance.collection('users');

// Perform the query to find documents matching the condition
    users.where('uid', isEqualTo: '${user?.uid}').get().then((querySnapshot) {
      // Iterate through the documents returned by the query
      querySnapshot.docs.forEach((doc) {
        // Update the document with the desired fields/values
        users
            .doc(doc.id)
            .update({'prime': true})
            .then((_) => print("Document Updated"))
            .catchError((error) => print("Failed to update document: $error"));
      });
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
  }
  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
  }
  openSession({required num amount}) {
    createOrder(amount: amount).then((orderId) {
      print(orderId);
      if (orderId.toString().isNotEmpty) {
        var options = {
          'key': razorPayKey, //Razor pay API Key
          'amount': amount, //in the smallest currency sub-unit.
          'name': 'Company Name.',
          'order_id': orderId, // Generate order_id using Orders API
          'description':
              'Description for order', //Order Description to be shown in razor pay page
          'timeout': 60, // in seconds
          'prefill': {
            'contact': '9123456789',
            'email': 'flutterwings304@gmail.com'
          } //contact number and email id of user
        };
        _razorpay.open(options);
      } else {}
    });
  }

  createOrder({
    required num amount,
  }) async {
    final myData = await ApiServices().razorPayApi(amount, "rcp_id_1");
    if (myData["status"] == "success") {
      return myData["body"]["id"];
    } else {
      return "";
    }
  }
}
