
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


import '../../../Widget/AppMessage.dart';
import 'exerciseDate.dart';
class patientExerciseList extends StatefulWidget {
  final String planId;
  final String userId;

  const patientExerciseList({Key? key, required this.planId, required this.userId}) : super(key: key);

  @override
  State<patientExerciseList> createState() => _patientExerciseListState();
}

late ImageProvider exerciseImg = AssetImage(AppImage.exercise);

class _patientExerciseListState extends State<patientExerciseList> {
  Set<String> displayedExercises = {}; // مجموعة لتتبع الـ exercises التي تم عرضها
@override
void initState(){
  super.initState();
  displayedExercises.clear();}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(text: 'Exercise List'),
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
        .where((entry) => entry.key != 'exercise')
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
    final exerciseName = exercise['exercise'];
    final exerciseLevel = exercise['level'];
    final exerciseplan = exercise['planId'];
    final exerciseKey = '$exerciseName-$exerciseLevel-$exerciseplan';

    if (displayedExercises.contains(exerciseKey)) {
    return false; // لا تعرض الـ exercise إذا تم عرضه بالفعل
    } else {
    displayedExercises.add(exerciseKey); // إضافة الـ exercise إلى المجموعة لتتبعها
    return exercise['planId'] == widget.planId;
    }
    }).toList();

    if (filteredExercises.isEmpty) {
    return Center(
    child: Text(
    'No reports found for the specified plan',
    style: TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    ),
    ),
    );
    }

    return ListView.builder(
    itemCount: filteredExercises.length,
    itemBuilder: (context, index) {
    final exerciseData = filteredExercises[index];

    final exerciseName = exerciseData['exercise'];
    final exerciseLevel = exerciseData['level'];

    return Padding(
    padding: EdgeInsets.symmetric(vertical: 5.0),
    child: SizedBox(
    height: 100.0,
    width: double.maxFinite,
    child: Card(
    elevation: 5,
    child: Center(
    child: ListTile(
    tileColor: Colors.white,
    leading: CircleAvatar(
    radius: 25.0,
    child: ClipOval(
    child: Image(
    image: exerciseImg,
    fit: BoxFit.cover,
    ),
    ),
    ),
      trailing: SizedBox(
        width: 70,
        height: 30,
      ),
      onTap: () {
        var selectedexercise =exerciseName;
        var level =exerciseLevel;

        AppRoutes.pushTo(
          context,
          exerciseDate(exercise: selectedexercise,planId:widget.planId,userId:widget.userId,level:level),
        );
      },
    title: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [Text(
      'Exercise Type:',
      style: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
    ),
      SizedBox(height: 5.0),
      Text(
        '$exerciseName level $exerciseLevel',
        style: TextStyle(
          fontSize: 16.0,
        ),
      ),
    ],
    ),
    ),
    ),
    ),
    ),
    );
    },
    );
    },
        ),
    );
  }
}
