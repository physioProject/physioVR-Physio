import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Database/Database.dart';
import 'AppColor.dart';
import 'AppIcons.dart';
import 'AppSize.dart';
import 'AppText.dart';

class AppWidget {
//scroll body===========================================================
  static Widget body({required Widget? child}) {
    return LayoutBuilder(builder: ((context, constraints) {
      return NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification? overscroll) {
            overscroll!.disallowIndicator();
            return true;
          },
          child: SingleChildScrollView(
              child: ConstrainedBox(
            constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight),
            child: IntrinsicHeight(child: child),
          )));
// AppText(text: LocaleKeys.myTeam.tr(), fontSize: WidgetSize.titleTextSize);
    }));
  }

  //===============================================================================================
  static List<PopupMenuItem> itemList({
    required action,
    bool? isChangePassword,
    bool? isShowNotification,
    String? helloName,
    void Function()? onTapChangePass,
    void Function()? onTapSetNotification,
  }) {
    return [
      PopupMenuItem(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: ListTile(
          leading: Icon(
            AppIcons.profile,
            color: AppColor.white,
          ),
          title: AppText(
            text: helloName ?? 'Hello Admin',
            fontSize: AppSize.subTextSize,
            color: AppColor.white,
          ),
        ),
      ),
      PopupMenuItem(
          child: Divider(
        color: AppColor.white,
        thickness: 1,
      )),
      //====================================

      isChangePassword != null
          ? PopupMenuItem(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: ListTile(
                onTap: onTapChangePass,
                leading: Icon(
                  Icons.lock,
                  color: AppColor.white,
                ),
                title: AppText(
                  text: 'Change password',
                  fontSize: AppSize.subTextSize,
                  color: AppColor.white,
                ),
              ),
            )
          : const PopupMenuItem(
              height: 0,
              padding: EdgeInsets.zero,
              child: SizedBox(
                height: 0,
              )),
      isChangePassword != null
          ? PopupMenuItem(
              child: Divider(
              color: AppColor.white,
              thickness: 1,
            ))
          : const PopupMenuItem(
              height: 0,
              padding: EdgeInsets.zero,
              child: SizedBox(
                height: 0,
              )),
      //====================================

      isShowNotification != null
          ? PopupMenuItem(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: ListTile(
                onTap: onTapSetNotification,
                leading: Icon(
                  Icons.notification_add,
                  color: AppColor.white,
                ),
                title: AppText(
                  text: 'Alerts',
                  fontSize: AppSize.subTextSize,
                  color: AppColor.white,
                ),
              ),
            )
          : const PopupMenuItem(
              height: 0,
              padding: EdgeInsets.zero,
              child: SizedBox(
                height: 0,
              )),
      isShowNotification != null
          ? PopupMenuItem(
              child: Divider(
              color: AppColor.white,
              thickness: 1,
            ))
          : const PopupMenuItem(
              height: 0,
              padding: EdgeInsets.zero,
              child: SizedBox(
                height: 0,
              )),
      //====================================
      PopupMenuItem(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: ListTile(
          onTap: action,
          leading: Icon(
            AppIcons.logout,
            color: AppColor.white,
          ),
          title: AppText(
            text: 'Log out',
            fontSize: AppSize.subTextSize,
            color: AppColor.white,
          ),
        ),
      ),
    ];
  }

  //======================random number=======================================
  static String randomNumber(int length) {
    const characters = '0123456789';
    Random random = Random();
    return String.fromCharCodes(Iterable.generate(length,
        (_) => characters.codeUnitAt(random.nextInt(characters.length))));
  }

//==================random upper char=============================================
  static String randomUpper(int length) {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    Random random = Random();
    return String.fromCharCodes(Iterable.generate(length,
        (_) => characters.codeUnitAt(random.nextInt(characters.length))));
  }

//==================random lower char=============================================
  static String randomLower(int length) {
    const characters = 'abcdefghijklmnopqrstuvwxyz';
    Random random = Random();
    return String.fromCharCodes(Iterable.generate(length,
        (_) => characters.codeUnitAt(random.nextInt(characters.length))));
  }

//==================random char=============================================
  static String randomCode(int length) {
    const characters = '#%^*_-!';
    Random random = Random();
    return String.fromCharCodes(Iterable.generate(length,
        (_) => characters.codeUnitAt(random.nextInt(characters.length))));
  }

//==================decoration=============================================
  static BoxDecoration decoration(
      {bool? shadow,
      bool? radiusOnlyTop,
      bool? radiusOnlyBottom,
      bool? radiusOnlyTopLeftButtomLeft,
      bool? radiusOnlyTopRightButtomRight,
      Color? color,
      double radius = 10,
      bool showBorder = false,
      Color? borderColor,
      double borderWidth = 0.5,
      ImageProvider<Object>? image,
      bool cover = false,
      ColorFilter? colorFilter,
      bool isGradient = false}) {
    return BoxDecoration(
        image: image == null
            ? null
            : DecorationImage(
                image: image,
                fit: cover == true ? BoxFit.cover : BoxFit.contain,
                colorFilter: colorFilter),
        border: showBorder == true
            ? Border.all(
                color: borderColor ?? AppColor.deepLightGrey,
                width: borderWidth)
            : null,
        color: isGradient == true ? null : (color ?? AppColor.white),
        borderRadius: radiusOnlyTop == true
            ? BorderRadius.only(
                topRight: Radius.circular(radius.r),
                topLeft: Radius.circular(radius.r),
              )
            : radiusOnlyBottom == true
                ? BorderRadius.only(
                    bottomLeft: Radius.circular(radius.r),
                    bottomRight: Radius.circular(radius.r))
                : radiusOnlyTopLeftButtomLeft == true
                    ? BorderRadius.only(
                        topLeft: Radius.circular(radius.r),
                        bottomLeft: Radius.circular(radius.r),
                      )
                    : radiusOnlyTopRightButtomRight == true
                        ? BorderRadius.only(
                            topRight: Radius.circular(radius.r),
                            bottomRight: Radius.circular(radius.r))
                        : BorderRadius.all(Radius.circular(radius.r)),
        boxShadow: shadow != null && shadow != false
            ? [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 4,
                  blurRadius: 4,
                  offset: const Offset(0, 0),
                ),
              ]
            : null);
  }
}
