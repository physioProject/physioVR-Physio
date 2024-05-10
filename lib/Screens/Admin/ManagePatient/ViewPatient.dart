import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:physio/Database/Database.dart';
import 'package:physio/Screens/Account/Login.dart';
import 'package:physio/Screens/Admin/ManagePatient/AddNewPatient.dart';
import 'package:physio/Screens/Admin/ManagePatient/UpdatePatient.dart';
import 'package:physio/Widget/AppBar.dart';
import 'package:physio/Widget/AppIcons.dart';
import 'package:physio/Widget/AppMessage.dart';
import 'package:physio/Widget/AppPopUpMen.dart';
import 'package:physio/Widget/AppRoutes.dart';
import 'package:physio/Widget/AppSize.dart';
import 'package:physio/Widget/AppText.dart';
import 'package:physio/Widget/generalWidget.dart';

import '../../../Widget/AppColor.dart';
import '../../../Widget/AppConstants.dart';
import '../../../Widget/AppLoading.dart';

class ViewPatient extends StatefulWidget {
  const ViewPatient({Key? key}) : super(key: key);

  @override
  State<ViewPatient> createState() => _ViewPatientState();
}

class _ViewPatientState extends State<ViewPatient> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
            text: AppMessage.managePatientB,
            leading: AppPopUpMen(
                icon: CircleAvatar(
                  backgroundColor: AppColor.black,
                  child: Icon(AppIcons.menu),
                ),
                menuList: AppWidget.itemList(action: () {
                  Database.logOut();
                  AppRoutes.pushReplacementTo(context, const Login());
                }))),
        floatingActionButton: FloatingActionButton(
            backgroundColor: AppColor.iconColor,
            elevation: 10,
            child: Icon(AppIcons.add),
            onPressed: () {
              AppRoutes.pushTo(context, const AddNewPatient());
            }),
        body: StreamBuilder(
            stream: AppConstants.userCollection
                .where('type', isEqualTo: AppConstants.typeIsPatient)
                .orderBy('activeUser', descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('${snapshot.error}'));
              }
              if (snapshot.hasData) {
                return body(context, snapshot);
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }));
  }

//=======================================================================
  Widget body(context, snapshot) {
    return snapshot.data.docs.length > 0
        ? ListView.builder(
      itemCount: snapshot.data.docs.length,
      itemBuilder: (context, i) {
        var data = snapshot.data.docs[i].data();
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 5.h),
          child: SizedBox(
            height: 100.h,
            width: double.maxFinite,
            child: Card(
              elevation: 5,
              child: Center(
                child: ListTile(
                  onTap: () {
                    print('Tapped on patient, navigating to UpdatePatient');
                    AppRoutes.pushTo(
                        context,
                        UpdatePatient(
                          docId: snapshot.data.docs[i].id,
                          firstName: data['firstName'],
                          lastName: data['lastName'],
                          phone: data['phone'],
                          dateOfBirth: (data['dateOfBirth'] as Timestamp).toDate() ?? DateTime.now(),
                          condition: data['condition'],
                          email: data['email'],
                          therapistName: data['therapistName'],
                        ));
                  },
                  tileColor: AppColor.white,
                  leading: InkWell(
//active account function==================================================================================================

                    onTap: () {
                      AppLoading.show(context, '', 'lode');
                      Database.sendPasswordToUser(data: data)
                          .then((v) async {
                        if (v == "done") {
                          await Database.updateAccountStatus(
                            docId: snapshot.data.docs[i].id,
                          );
                          if (!mounted) return;
                          Navigator.pop(context);
                          AppLoading.show(context, AppMessage.emailTx,
                              AppMessage.sendEmail);
                        } else {
                          Navigator.pop(context);
                          AppLoading.show(context, AppMessage.emailTx,
                              '${AppMessage.error} ${AppMessage.sureEmail}');
                        }
                      });
                    },

                    child: Icon(
                      AppIcons.profile,
                      size: 45.spMin,
                      color: data['status'] == 0 ? AppColor.black : null,
                    ),
                  ),
//active account text==================================================================================================
                  subtitle: AppText(
                    text: data['status'] == 0
                        ? AppMessage.accountNotActive
                        : 'Password send',
                    fontSize: AppSize.subTextSize,
                  ),
//active user icon==================================================================================================
                  trailing: InkWell(
                    onTap: () async {
                      AppLoading.show(
                          context,
                          data['activeUser'] == true
                              ? 'Deactivate the user'
                              : 'User activation',
                          data['activeUser'] == true
                              ? 'Do you want to disable the account of this user?'
                              : 'Do you want to activate the account?',
                          showButtom: true, noFunction: () {
                        Navigator.pop(context);
                      }, yesFunction: () async {
                        Navigator.pop(context);

                        await Database.updateActiveUser(
                            docId: snapshot.data.docs[i].id,
                            userId:data['userId'],
                            type:data['type'],
                            activeUser: data['activeUser'] == true
                                ? false
                                : true);
                      });
                    },
                    child: Icon(
                      data['activeUser'] == true
                          ? AppIcons.unActive
                          : AppIcons.active,
                      size: 60.spMin,
                      color: data['activeUser'] == true
                          ? AppColor.activeColor
                          : AppColor.unActiveColor,
                    ),
                  ),
//name icon==================================================================================================
                  title: AppText(
                    text: data['firstName'] + ' ' + data['lastName'],
                    fontSize: AppSize.subTextSize,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    )
        : Center(
      child: AppText(
          text: AppMessage.noData,
          fontSize: AppSize.subTextSize,
          fontWeight: FontWeight.bold),
    );
  }
}

//===
