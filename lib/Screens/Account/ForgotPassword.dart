import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:physio/Widget/AppButtons.dart';
import 'package:physio/Widget/AppTextFields.dart';
import '../../Database/sqlLite.dart';
import '../../Widget/AppBar.dart';
import '../../Widget/AppLoading.dart';
import '../../Widget/AppMessage.dart';
import '../../Widget/AppValidator.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> passReset() async {
    final email = emailController.text.trim();

//=============================Check if the user is registered===============================
    try {
      if (await isEmailRegistered(email)) {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        if (!mounted) return;
        AppLoading.show(context, AppMessage.sendEmail, AppMessage.done);

        ///delete logging restriction
        int de = await DatabaseHelper.deleteLogCounter();
        print('deleteLogCounter is $de');
      } else {
        if (!mounted) return;
        AppLoading.show(
            context, AppMessage.notsendEmail, AppMessage.userNotFound);
      }
    }
    //===========================Catch other exceptions =============================
    on FirebaseAuthException catch (e) {
      showAlertDialog('Error: ${e.message}');
    } catch (e) {
      showAlertDialog('An unexpected error occurred.');
    }
  }

  bool isEmailValid(String email) {
    return EmailValidator.validate(email);
  }

  Future<bool> isEmailRegistered(String email) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(message),
        );
      },
    );
  }

  void showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(message),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(text: 'Forgot Password'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                'Please enter your email so we can send you a reset link',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: 400.0,
              height: 50.0,
              child: AppTextFields(
                controller: emailController,
                labelText: AppMessage.emailTx,
                validator: (v) => AppValidator.validatorEmail(v),
                obscureText: false,
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: 400.0,
              height: 50.0,
              child: AppButtons(
                onPressed: passReset,
                text: 'Reset password',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
