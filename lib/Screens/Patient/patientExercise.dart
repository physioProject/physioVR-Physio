import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Widget/AppBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

import '../../../Widget/AppMessage.dart';class patientExercise extends StatefulWidget {
  final String planId;
  const patientExercise({Key? key, required this.planId}) : super(key: key);

  @override
  State<patientExercise> createState() => _patientExerciseState();
}

late ImageProvider exerciseImg = AssetImage(AppImage.exercise);

class _patientExerciseState extends State<patientExercise> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(text: 'Exercise List'),
      body: StreamBuilder(
        stream: AppConstants.exerciseCollection
            .where('planId', isEqualTo: widget.planId)
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
        var docId = snapshot.data.docs[i].id; // Get the doc id
        var exercises = data['exercise'].split(','); // Split exercises

        return Column(
          children: exercises
              .map<Widget>(
                (exercise) => Padding(
              padding: EdgeInsets.symmetric(vertical: 5.h),
              child: SizedBox(
                height: 100.h,
                width: double.maxFinite,
                child: Card(
                  elevation: 5,
                  child: Center(
                    child: ListTile(
                      tileColor: AppColor.white,
                      leading: CircleAvatar(
                        radius: 25.sp,
                        child: ClipOval(
                          child: Image(
                            image: exerciseImg,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Exercise Type:', // Header text
                            style: TextStyle(
                              fontSize: AppSize.subTextSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5), // Add spacing
                          AppText(
                            text: exercise.trim(), // Remove leading/trailing spaces
                            fontSize: AppSize.subTextSize,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
                ),
          )
              .toList(),
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
