import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'AppColor.dart';
import 'AppSize.dart';

class AppTextFields extends StatelessWidget {
  final bool? obscureText;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? labelText;
  final int? minLines;
  final int? maxLines;
  final bool? enable;
  final FontWeight? fontWeight;
  final void Function()? onTap;
  final bool? customDesign;
  final Color? fillColor;
  const AppTextFields({
    Key? key,
    required this.validator,
    this.onTap,
    this.inputFormatters,
    this.keyboardType,
    required this.controller,
    required this.labelText,
    this.fontWeight,
    this.obscureText,
    this.minLines,
    this.maxLines,
    this.enable,
    this.customDesign,
    this.fillColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enable ?? true,
      minLines: minLines ?? 1,
      maxLines: maxLines ?? 1,
      onTap: onTap,
      obscureText: obscureText ?? false,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      autofocus: false,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      controller: controller,
      style: TextStyle(
          color:
              fillColor != null ? AppColor.white : AppColor.mainTextFieldsColor,
          fontSize: AppSize.textFieldsFontSize),
      decoration: InputDecoration(
          filled: true,
          hintStyle: TextStyle(
              color: fillColor != null
                  ? AppColor.white
                  : AppColor.labelTextFieldsColor,
              fontSize: AppSize.textFieldsHintSize),
          fillColor: fillColor ?? AppColor.white,
          labelStyle: TextStyle(
              color: fillColor != null
                  ? AppColor.white
                  : AppColor.labelTextFieldsColor,
              fontSize: AppSize.textFieldsFontSize),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
                fillColor != null ? 20.spMin : AppSize.textFieldsBorderRadius),
            borderSide: BorderSide(
              color: AppColor.textFieldBorderColor,
              width:
                  fillColor == null ? AppSize.textFieldsBorderWidth : 2.spMin,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
                fillColor != null ? 20.spMin : AppSize.textFieldsBorderRadius),
            borderSide: BorderSide(
              color: AppColor.buttonsColor,
              width:
                  fillColor == null ? AppSize.textFieldsBorderWidth : 2.spMin,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
                fillColor != null ? 20.spMin : AppSize.textFieldsBorderRadius),
            borderSide: BorderSide(
              color: AppColor.textFieldBorderColor,
              width:
                  fillColor == null ? AppSize.textFieldsBorderWidth : 2.spMin,
            ),
          ),
          labelText: labelText,
          //errorStyle: TextStyle(color: AppColor.errorColor, fontSize: WidgetSize.errorSize),
          contentPadding: EdgeInsets.all(AppSize.contentPadding)),
    );
  }
}
