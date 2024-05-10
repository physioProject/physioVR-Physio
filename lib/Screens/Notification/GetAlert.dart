import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:physio/Screens/Notification/AddAlert.dart';
import 'package:physio/Widget/AppColor.dart';
import 'package:physio/Widget/AppIcons.dart';
import 'package:physio/Widget/AppMessage.dart';
import 'package:physio/Widget/AppRoutes.dart';
import 'package:physio/Widget/AppSize.dart';
import 'package:physio/Widget/AppText.dart';

import '../../Database/sqlLite.dart';
import '../../Widget/AppBar.dart';
import '../../Widget/AppButtons.dart';
import '../../Widget/AppLoading.dart';
import '../../Widget/AppTextFields.dart';
import '../../Widget/AppValidator.dart';
import '../../Widget/GeneralWidget.dart';
import 'initial_notification.dart';

class GetAlert extends StatefulWidget {
  const GetAlert({super.key});

  @override
  State<GetAlert> createState() => _GetAlertState();
}

class _GetAlertState extends State<GetAlert> {
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  List<Map<String, dynamic>> allAlerts = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lode();
  }

  lode() async {
    // await DatabaseHelper.deleteDatabase();
    allAlerts = await DatabaseHelper.getAllAlerts();
    setState(() {});
    print('allAlerts: $allAlerts');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        text: 'Alerts',
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.0.w, top: 5.h),
            child: IconButton(
                onPressed: () {
                  Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const AddAlert()))
                      .then((value) {
                    if (clickAdd) {
                      setState(() {
                        lode();
                        clickAdd = false;
                      });
                    }
                  });
                },
                icon: CircleAvatar(
                    backgroundColor: AppColor.black,
                    child: Icon(
                      AppIcons.add,
                      color: AppColor.white,
                    ))),
          )
        ],
      ),
      body: allAlerts.isEmpty
          ? Align(
              alignment: AlignmentDirectional.center,
              child: AppText(
                text: AppMessage.noData,
                fontSize: AppSize.subTextSize,
                fontWeight: FontWeight.bold,
                color: AppColor.black,
              ),
            )
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //format text=====================================================================================================================
                  Padding(
                    padding: EdgeInsets.only(left: 8.0.w),
                    child: AppText(
                      text: 'time in 24 format',
                      fontSize: AppSize.subTextSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Expanded(
                      child: ListView.builder(
                          itemCount: allAlerts.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext contextBuilder, int i) {
                            var e = allAlerts[i];
                            return Card(
                              child: ListTile(
                                onTap: null,
                                minVerticalPadding: 10.h,
                                title: AppText(
                                  //title -time =====================================================================================================================

                                  text:
                                      '${e['title']}  ${e['hour']}:${e['minute']}',
                                  fontSize: AppSize.subTextSize,
                                  fontWeight: FontWeight.bold,
                                ),
                                //body text=====================================================================================================================

                                subtitle: Text(e['body'].toString()),
                                trailing: InkWell(
                                  //active-not active icon =====================================================================================================================

                                  onTap: e['active'] == 0
                                      ? null
                                      : () async {
                                          AppLoading.show(
                                              context,
                                              AppMessage.alerts,
                                              AppMessage.unActiveNotification,
                                              showButtom: true, noFunction: () {
                                            Navigator.pop(context);
                                          }, yesFunction: () async {
                                            LocalNotificationServices
                                                .cancelNotification(e['id']);
                                            await DatabaseHelper.updateAlert(
                                                    e['id'], e['active'])
                                                .then((value) {
                                              lode();
                                              Navigator.pop(context);
                                              AppLoading.show(
                                                  context,
                                                  AppMessage.alerts,
                                                  AppMessage.done);
                                            });
                                          });
                                        },
                                  //active-not active icon =====================================================================================================================

                                  child: Icon(
                                    e['active'] == 1
                                        ? AppIcons.activeNotification
                                        : AppIcons.notactiveNotification,
                                    color: e['active'] == 1
                                        ? AppColor.activeColor
                                        : AppColor.errorColor,
                                    size: AppSize.iconSize,
                                  ),
                                ),
                              ),
                            );
                          })),
                ],
              ),
            ),
    );
  }
}
