import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:physio/Screens/Notification/GetAlert.dart';
import 'package:physio/Screens/Patient/patientExercise.dart';
import '../../Database/Database.dart';
import '../../Widget/AppButtons.dart';
import '../../Widget/AppIcons.dart';
import '../../Widget/AppImage.dart';

import 'package:physio/Screens/Therapist/TherapistHome.dart';
import '../../../Widget/AppBar.dart';
import '../../../Widget/AppMessage.dart';
import '../../Widget/AppColor.dart';
import '../../Widget/AppConstants.dart';
import '../../Widget/AppPopUpMen.dart';
import '../../Widget/AppRoutes.dart';
import '../../Widget/AppSize.dart';
import '../../Widget/AppText.dart';
import '../../Widget/GeneralWidget.dart';
import '../Account/Login.dart';
import 'ChangePass.dart';
import '../Notification/AddAlert.dart';

class PatientPlanView extends StatefulWidget {
  final String name;
  final String patientId;
  const PatientPlanView({
    Key? key,
    required this.name,
    required this.patientId,
  }) : super(key: key);

  @override
  State<PatientPlanView> createState() => _PatientPlanViewState();
}

class _PatientPlanViewState extends State<PatientPlanView> {
  late ImageProvider exerciseImg = AssetImage(AppImage.plan);

  Widget buildBody(BuildContext context, AsyncSnapshot<QuerySnapshot>? snapshot) {

    if (snapshot == null ||!snapshot.hasData||  snapshot.data == null) {
      return Center(
        child: AppText(
          text: AppMessage.noData,
          fontSize: AppSize.subTextSize,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    var dataDocs = snapshot.data!.docs;
    return ListView.builder(
      itemCount: dataDocs.length,
      itemBuilder: (context, i) {
        var data = dataDocs[i].data() as Map<String, dynamic>;
        var documentId = dataDocs[i].id;
        var finishDate;
        var isExerciseFinished = false;

        try {
          finishDate = DateTime.parse(data['finishDate'].toString());
          isExerciseFinished = finishDate.isBefore(DateTime.now());
        } catch (error) {
          print('Error parsing finishDate: $error');
        }

        var exerciseImage = Image(
          image: exerciseImg,

          color: isExerciseFinished ? Colors.grey : null,
          colorBlendMode: BlendMode.saturation,
        );

        return Padding(
          padding: EdgeInsets.symmetric(vertical: 5.h),
          child: SizedBox(
            height: 100.h,
            width: double.maxFinite,
            child: Card(
              elevation: 5,
              child: ListTile(
                tileColor: AppColor.white,
                leading: CircleAvatar(
                  radius: 30.sp,
                    child: exerciseImage,

                ),
                trailing: SizedBox(
                  width: 70,
                  height: 30,
                ),
                onTap: () {
                  var selectedPlan = (dataDocs[i].data() as Map<String, dynamic>)['planId'] as String?; // Explicitly handle as Object and then cast to String
                  if (selectedPlan != null) {
                    AppRoutes.pushTo(
                      context,
                      patientExercise(planId: selectedPlan),
                    );
                  } else {
                    print('Invalid planId');
                  }
                },
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Plan Name:', // Header text
                      style: TextStyle(
                        fontSize: AppSize.subTextSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5), // Add spacing
                    Text(
                      data['planName'].toString(),
                      style: TextStyle(
                        fontSize: AppSize.subTextSize,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          text: AppMessage.myPlan,
          leading: AppPopUpMen(
            icon: CircleAvatar(
              backgroundColor: AppColor.black,
              child: Icon(AppIcons.menu),
            ),
            menuList: AppWidget.itemList(
               onTapChangePass: () =>
                AppRoutes.pushTo(context, const ChangePass()),
            onTapSetNotification: () =>
                AppRoutes.pushTo(context, const GetAlert()),
            isChangePassword: true,
            isShowNotification: true,
              helloName: 'Hello Patient ${widget.name}',
              action: () {
                Database.logOut();
                AppRoutes.pushReplacementTo(context, const Login());
              },
            ),
          ),
        ),


      body: StreamBuilder(
        stream: AppConstants.exerciseCollection
            .where('userId', isEqualTo: widget.patientId)
            .orderBy('finishDate', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }
          if (snapshot.hasData) {
            return buildBody(context, snapshot);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
