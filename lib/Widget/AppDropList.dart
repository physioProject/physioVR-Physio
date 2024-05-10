import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'AppColor.dart';
import 'AppSize.dart';
import 'AppText.dart';

class AppDropList extends StatelessWidget {
  final List<String> listItem;
  final String? Function(String?)? validator;
  final String? hintText;
  final String? dropValue;
  final bool? friezeText;
  final Color? fillColor;
  final void Function(String?)? onChanged;
  const AppDropList(
      {Key? key,
      required this.listItem,
      required this.validator,
      required this.hintText,
      required this.onChanged,
      required this.dropValue,
      this.friezeText,
      this.fillColor, required String multiSelectSeparator, required bool isMultiSelect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<String>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      hint: AppText(
        fontSize: AppSize.textFieldsFontSize,
        text: hintText ?? '',
        color:
            fillColor != null ? AppColor.white : AppColor.labelTextFieldsColor,
      ),
      items: listItem
          .map((item) => DropdownMenuItem(
                // alignment: Alignment.centerRight,
                value: item,
                child: AppText(
                  fontSize: AppSize.textFieldsFontSize,
                  text: item,
                  color: fillColor != null
                      ? AppColor.white
                      : AppColor.labelTextFieldsColor,
                ),
              ))
          .toList(),
      value: dropValue,
      decoration: InputDecoration(
          filled: true,
          fillColor: fillColor ?? AppColor.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
                fillColor != null ? 20.spMin : AppSize.textFieldsBorderRadius),
            borderSide: BorderSide(
              color: Colors.blue,
              width: AppSize.textFieldsBorderWidth,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
                fillColor != null ? 20.spMin : AppSize.textFieldsBorderRadius),
            borderSide: BorderSide(
              color: AppColor.buttonsColor,
              width: AppSize.textFieldsBorderWidth,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
                fillColor != null ? 20.spMin : AppSize.textFieldsBorderRadius),
            borderSide: BorderSide(
              color: AppColor.textFieldBorderColor,
              width: AppSize.textFieldsBorderWidth,
            ),
          ),
          //labelText: labelText,
          //errorStyle: TextStyle(color: AppColor.errorColor, fontSize: WidgetSize.errorSize),
          contentPadding: EdgeInsets.all(AppSize.dropListContentPadding)),
      onChanged: friezeText == true ? null : onChanged,
      dropdownMaxHeight: 300.h,
      dropdownDecoration: BoxDecoration(
          color: fillColor != null ? AppColor.black : AppColor.white,
          borderRadius: BorderRadius.all(
              Radius.circular(AppSize.textFieldsBorderRadius))),
      iconDisabledColor: AppColor.buttonsColor,
      iconEnabledColor: AppColor.buttonsColor,
      scrollbarAlwaysShow: true,
    );
  }
}

