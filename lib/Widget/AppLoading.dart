import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'AppButtons.dart';
import 'AppColor.dart';
import 'AppSize.dart';
import 'AppText.dart';

class AppLoading {
  static show(context, String title, String content,
      {bool showButtom = false,
      void Function()? yesFunction,
      void Function()? noFunction,
      Widget? customContin,
      double? higth}) {
    return showDialog(
        //barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            titlePadding: EdgeInsets.zero,
            elevation: 0,

            backgroundColor:
                content == "lode" ? Colors.transparent : AppColor.white,

//tittle-------------------------------------------------------------------

            title: content != "lode"
                ? Container(
                    decoration: BoxDecoration(
                        color: AppColor.black,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.r),
                            topRight: Radius.circular(10.r))),
                    width: double.infinity,
                    height: 40.h,
                    child: Center(
                      child: AppText(
                        fontSize: AppSize.buttonsFontSize,
                        text: title,
                        color: AppColor.white,
                      ),
                    ),
                  )
                : const SizedBox(),
//continent area-------------------------------------------------------------------

            content: content != "lode"
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 10.h),
//continent tittle-------------------------------------------------------------------
                              Flexible(
                                child: AppText(
                                  fontSize: AppSize.subTextSize + 2,
                                  text: content,
                                  color: AppColor.black,
                                  align: TextAlign.center,
                                ),
                              ),

//divider-------------------------------------------------------------------

                              showButtom
                                  ? Divider(
                                      thickness: 1,
                                      color: AppColor.appBarColor,
                                    )
                                  : const SizedBox(),
                              SizedBox(height: 10.h),
//bottoms-------------------------------------------------------------------

                              showButtom
                                  ? Flexible(
                                      flex: 2,
                                      child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
// yes bottoms-------------------------------------------------------------------
                                            Expanded(
                                                child: AppButtons(
                                              onPressed: yesFunction,
                                              text: 'yes',
                                              bagColor: AppColor.appBarColor,
                                            )),

                                            SizedBox(width: 20.w),
//no buttom-------------------------------------------------------------------
                                            Expanded(
                                              child: AppButtons(
                                                onPressed: noFunction,
                                                text: 'no',
                                                bagColor: AppColor.appBarColor,
                                              ),
                                            )
                                          ]),
                                    )
                                  : const SizedBox(),
                            ],
                          )),
                    ],
                  )
//Show Waiting image-------------------------------------------------------
                : SizedBox(
                    width: double.infinity,
                    height: 200.h,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: CircularProgressIndicator(
                        color: AppColor.white,
                      ),
                    ),
                  ),

//Show bottoms -------------------------------------------------------

            actions: [
              showButtom == false && content != "lode"
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: AppButtons(
                        text: 'OK',
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        bagColor: AppColor.iconColor,
                      )),
                    )
                  : const SizedBox()
            ],
          );
        });
  }
}
