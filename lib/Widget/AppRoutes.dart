import 'package:flutter/material.dart';

class AppRoutes {

//pushTo========================================================================
  static void pushTo(BuildContext context, pageName) {
    Navigator.push(
        context,
        PageRouteBuilder(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return child;
          },
          pageBuilder: (context, animation, secondaryAnimation) => pageName,
        ));
  }

//pushReplacement========================================================================
  static void pushReplacementTo(BuildContext context, pageName) {
    Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return child;
          },
          pageBuilder: (context, animation, secondaryAnimation) => pageName,
        ));
  }
}