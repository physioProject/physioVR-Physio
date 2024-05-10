import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'package:physio/Screens/Account/Login.dart';
import 'package:physio/Screens/Therapist/TherapistHome.dart';

import '../../Widget/AppImage.dart';
import '../Patient/ChangePass.dart';

class ViewPatients extends StatefulWidget {
  final String therapistId;
  final String name;
   ViewPatients({Key? key, required this.therapistId, required this.name}) : super(key: key);

  @override
  State<ViewPatients> createState() => _ViewTherapistState();
}
String selectedUser='';
class _ViewTherapistState extends State<ViewPatients> {
  late ImageProvider exerciseImg= AssetImage(AppImage.pro);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
          text: AppMessage.PatientList,
          leading: AppPopUpMen(
              icon: CircleAvatar(
                backgroundColor: AppColor.black,
                child: Icon(AppIcons.menu),
              ),
              menuList: AppWidget.itemList(
                  onTapChangePass: () =>
                      AppRoutes.pushTo(context, const ChangePass()),
                  isChangePassword: true,
                  helloName: 'Hello Therapist ${widget.name}',
                  action: () {
                    Database.logOut();
                    AppRoutes.pushReplacementTo(context, const Login());
                  }))),
      body: StreamBuilder(
        stream: AppConstants.userCollection
            .where('type', isEqualTo: AppConstants.typeIsPatient)
            .where('therapistId', isEqualTo: widget.therapistId)
         .where('activeUser', isEqualTo: true)
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
        },
      ),
    );
  }

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
                  onTap:() {
                    setState((){
                      selectedUser=snapshot.data.docs[i].data()['userId'];});
                    AppRoutes.pushTo(context,TherapistHome(PatientId:selectedUser));},

                  tileColor: AppColor.white,
                  leading: CircleAvatar(
                    radius: 25.0,
                    child: ClipOval(
                      child: Image(
                        image: exerciseImg,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
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
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

