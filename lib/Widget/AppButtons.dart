import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'AppColor.dart';
import 'AppSize.dart';
import 'AppText.dart';

class AppButtons extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final Color? bagColor;
  final Color? textStyleColor;
  final TextOverflow? overflow;
  final double? elevation;
  final double? width;
  const AppButtons({
    Key? key,
    required this.onPressed,
    required this.text,
    this.bagColor,
    this.overflow,
    this.textStyleColor,
    this.width,
    this.elevation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: 50.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.textFieldsBorderRadius),
          ),
          backgroundColor: bagColor ?? AppColor.buttonsColor,
          elevation: elevation ?? 1.0,
          textStyle: TextStyle(
              fontFamily: GoogleFonts.quicksand().fontFamily,
              color: textStyleColor ?? AppColor.buttonsTextColor,
              fontSize: AppSize.buttonsFontSize,
              fontStyle: FontStyle.normal),
        ),
        onPressed: onPressed,
        child: AppText(
            fontSize: AppSize.buttonsFontSize,
            text: text,
            color: textStyleColor ?? AppColor.buttonsTextColor,
            fontFamily: GoogleFonts.quicksand().fontFamily),
      ),
    );
  }
}
