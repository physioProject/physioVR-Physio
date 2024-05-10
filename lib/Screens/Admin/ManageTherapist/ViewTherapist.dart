import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:physio/Screens/Admin/ManageTherapist/AddNewTherapist.dart';

import '../../../Database/Database.dart';
import '../../../Widget/AppBar.dart';
import '../../../Widget/AppColor.dart';
import '../../../Widget/AppConstants.dart';
import '../../../Widget/AppIcons.dart';
import '../../../Widget/AppLoading.dart';
import '../../../Widget/AppMessage.dart';
import '../../../Widget/AppPopUpMen.dart';
import '../../../Widget/AppRoutes.dart';
import '../../../Widget/AppSize.dart';
import '../../../Widget/AppText.dart';
import '../../../Widget/generalWidget.dart';
import '../../Account/Login.dart';
import 'UpdateTherapist.dart';

class ViewTherapist extends StatefulWidget {
  const ViewTherapist({Key? key}) : super(key: key);

  @override
  State<ViewTherapist> createState() => _ViewTherapistState();
}

class _ViewTherapistState extends State<ViewTherapist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
            text: AppMessage.manageTherapistB,
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
              AppRoutes.pushTo(context, const AddNewTherapist());
            }),
        body: StreamBuilder(
            stream: AppConstants.userCollection
                .where('type', isEqualTo: AppConstants.typeIsTherapist)
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
                    AppRoutes.pushTo(
                        context,
                        UpdateTherapist(
                            docId: snapshot.data.docs[i].id,
                            firstName: data['firstName'],
                            lastName: data['lastName'],
                            phone: data['phone'],
                            email: data['email'],
                            userId: data['userId']));
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
                        : '',
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

//==
