import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:physio/Screens/Notification/GetAlert.dart';
import 'package:physio/Screens/Notification/NotificationController.dart';
import 'package:physio/Widget/AppColor.dart';
import 'package:physio/Widget/AppRoutes.dart';
import 'package:physio/Widget/AppSize.dart';
import 'package:physio/Widget/AppText.dart';

import '../../Database/sqlLite.dart';
import '../../Widget/AppBar.dart';
import '../../Widget/AppButtons.dart';
import '../../Widget/AppLoading.dart';
import '../../Widget/AppMessage.dart';
import '../../Widget/AppTextFields.dart';
import '../../Widget/AppValidator.dart';
import '../../Widget/GeneralWidget.dart';
import 'MessageDetails.dart';
import 'initial_notification.dart';

bool clickAdd = false;

class AddAlert extends StatefulWidget {
  const AddAlert({super.key});

  @override
  State<AddAlert> createState() => _AddAlertState();
}

class _AddAlertState extends State<AddAlert> {
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  TimeOfDay? time;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        text: 'Set Notification',
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ///body=================================================================================
              AppTextFields(
                controller: titleController,
                labelText: 'Enter message title',
                validator: (v) => AppValidator.validatorEmpty(v),
              ),
              SizedBox(
                height: 10.h,
              ),

              ///title================================================================================
              AppTextFields(
                controller: bodyController,
                labelText: 'Enter message body',
                validator: (v) => AppValidator.validatorEmpty(v),
              ),
              SizedBox(
                height: 10.h,
              ),

              ///time=================================================================================
              showRow(
                  label: 'Select time',
                  child: InkWell(
                    onTap: () async {
                      time = await show();
                      setState(() {});
                      print('selectedTime: ${time?.hour}-${time?.minute}');
                    },
                    child: Container(
                      height: 40.h,
                      decoration: AppWidget.decoration(
                          shadow: false,
                          radius: AppSize.textFieldsBorderRadius),
                      child: Center(
                        child: AppText(
                          text: time == null
                              ? '${TimeOfDay.now().hourOfPeriod.toString().padLeft(2, '0')}:${TimeOfDay.now().minute.toString().padLeft(2, '0')} ${TimeOfDay.now().hour >= 1 && TimeOfDay.now().hour < 12 ? 'AM' : 'PM'}'
                              : '${time?.hourOfPeriod.toString().padLeft(2, '0')}:${time?.minute.toString().padLeft(2, '0')} ${time!.hour >= 1 && time!.hour < 12 ? 'AM' : 'PM'}',
                          fontSize: AppSize.textFieldsFontSize,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  )),
              SizedBox(
                height: 10.h,
              ),

              ///repeat=================================================================================ظ

              ///button=================================================================================
              AppButtons(
                onPressed: () async {
                  if (formKey.currentState?.validate() == true) {
                    int id = int.parse(AppWidget.randomNumber(5));
                    print(id);
                    MessageDetails message = MessageDetails(
                      id: id,
                      title: titleController.text,
                      body: bodyController.text,
                      hour: time == null ? TimeOfDay.now().hour : time!.hour,
                      minute:
                          time == null ? TimeOfDay.now().minute : time!.minute,
                      repeats:false,
                      active: 1,
                    );
                    LocalNotificationServices.showNotification(message);
                    Future.delayed(const Duration(seconds: 4));
                    await DatabaseHelper.addAlerts(message);
                    setState(() {
                      clickAdd = true;
                    });
                    if (!mounted) return;
                    Navigator.pop(context);
                    AppLoading.show(context, AppMessage.add, AppMessage.done);
                  }
                },
                text: 'Save',
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///==========================================================
  Future<TimeOfDay?> show() {
    Future<TimeOfDay?> selectedTime = showTimePicker(
      initialEntryMode: TimePickerEntryMode.dialOnly,
      context: context,
      initialTime: TimeOfDay.now(),
    );

    return selectedTime;
  }

  ///============================================================================
  showRow({required String label, required Widget child}) {
    return Row(
      children: [
        Expanded(
            child: Container(
          padding: EdgeInsets.only(left: 10.w),
          height: 40.h,
          decoration: AppWidget.decoration(
              shadow: false, radius: AppSize.textFieldsBorderRadius),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: AppText(
              text: label,
              fontSize: AppSize.textFieldsFontSize,
            ),
          ),
        )),
        SizedBox(
          width: 10.w,
        ),
        Expanded(child: child),
      ],
    );
  }
}
