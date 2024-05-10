
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:physio/Screens/Therapist/reportPage.dart';

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


import '../../../Widget/AppMessage.dart';import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Widget/AppText.dart';
import '../../Widget/GeneralWidget.dart';
import '../Account/Login.dart';
import '../../../Widget/AppMessage.dart';
class exerciseDate extends StatefulWidget {
  final String planId;
  final String userId;
  final String level;
  final String exercise;

  const exerciseDate({
    Key? key,
    required this.planId,
    required this.userId,
    required this.level,
    required this.exercise,
  }) : super(key: key);

  @override
  State<exerciseDate> createState() => _ExerciseDateState();
}

class _ExerciseDateState extends State<exerciseDate> {
  late ImageProvider exerciseImg = AssetImage(AppImage.date);
  List<String> selectedDates = [];
  bool isButtonEnabled = false;
  bool selectAll = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(text: 'Exercise date'),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('reports').doc(widget.userId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final reportData = snapshot.data?.data() as Map<String, dynamic>?;
          if (reportData == null || reportData.isEmpty) {
            return Center(
              child: Text(
                'No data',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
          final exercises = reportData.entries
              .where((entry) => entry.key != 'date')
              .map((entry) => entry.value)
              .toList();
          if (exercises.isEmpty) {
            return Center(
              child: Text(
                'No exercises found',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
          final filteredExercises = exercises.where((exercise) {
            return exercise['planId'] == widget.planId &&
                exercise['exercise'] == widget.exercise &&
                exercise['level'] == widget.level;
          }).toList();
          if (filteredExercises.isEmpty) {
            return Center(
              child: Text(
                'No date found for the specified exercise',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
          final uniqueDates = filteredExercises.map((exercise) => exercise['date'].toString()).toSet();
          final sortedDates = uniqueDates.toList()..sort();
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: sortedDates.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Card(elevation: 5,
                        color: Colors.white,
                        child: CheckboxListTile(
                          activeColor: Colors.green,
                          title: Text(
                            'Select All',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          value: selectAll,
                          onChanged: (selected) {
                            setState(() {
                              selectAll = selected!;
                              if (selectAll) {
                                selectedDates = sortedDates;
                                isButtonEnabled = true;
                              } else {
                                selectedDates.clear();
                                isButtonEnabled = false;
                              }
                            });
                          },
                        ),
                      );
                    }
                    final date = sortedDates[index - 1];
                    final isSelected = selectedDates.contains(date);
                    return Card(elevation: 5,


                      child: CheckboxListTile(
                        activeColor: Colors.green,

                        title: Text(
                          'Exercise Date:',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '$date',
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        value: isSelected,
                        onChanged: (selected) {
                          setState(() {
                            if (selected!) {
                              selectedDates.add(date);
                            } else {
                              selectedDates.remove(date);
                            }
                            isButtonEnabled = selectedDates.isNotEmpty;
                            selectAll = false;
                          });
                        },
                      ),
                    );
                  },
                ),
              ), SizedBox(height: 20.h),

    ElevatedButton(
        onPressed: isButtonEnabled
            ? () {
          if (selectedDates.isNotEmpty) {
            AppRoutes.pushTo(
              context,
              reportPage(
                exercise: widget.exercise,
                planId: widget.planId,
                userId: widget.userId,
                level: widget.level,
                dates: selectedDates,
              ),
            );
          }
        }
            : null,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.disabled)) {
              return Colors.grey; // لون رمادي عند التعطيل
            }
            return Colors.black; // لون أسود عند التفعيل
          }),
          minimumSize: MaterialStateProperty.all(Size(320, 50)), // تعيين حجم البتون
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Generate Report',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,

                // تعيين حجم الخط
              ),
            ),
          ],
        ),
      )
      ,SizedBox(height: 20.h),
    ],
    );
    },
        ),
    );
  }
}
