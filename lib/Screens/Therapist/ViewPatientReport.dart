import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:physio/Screens/Therapist/patientExerciseList.dart';
import '../../Widget/AppButtons.dart';
import '../../Widget/AppImage.dart';
import '../../../Widget/AppBar.dart';
import '../../../Widget/AppMessage.dart';
import '../../Widget/AppColor.dart';
import '../../Widget/AppConstants.dart';
import '../../Widget/AppIcons.dart';
import '../../Widget/AppLoading.dart';
import '../../Widget/AppRoutes.dart';
import 'package:physio/Screens/Therapist/AddNewExercise.dart';
import '../../Widget/AppSize.dart';
import '../../Widget/AppText.dart';
import 'package:physio/Screens/Therapist/UpdateExercise.dart';
import 'package:physio/Screens/Therapist/Repeat.dart';


  class ViewPatientReport extends StatefulWidget {
  final String PatientId;
  const ViewPatientReport({Key? key,required this.PatientId}) : super(key: key);

  @override
  State<ViewPatientReport> createState() => _ViewPatientReportState();
}

class _ViewPatientReportState extends State<ViewPatientReport> {
  late ImageProvider exerciseImg= AssetImage(AppImage.plan);






  Widget body(BuildContext context, AsyncSnapshot<QuerySnapshot>? snapshot) {
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
    return dataDocs.length > 0
        ? ListView.builder(
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

        var exerciseImage =
           Image(
            image: exerciseImg,
            fit:BoxFit.scaleDown,
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
              child: Center(
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
                    var selectedPlan =
                    (snapshot.data!.docs[i].data()as Map<String,dynamic>)['planId']?.toString();
                    if (selectedPlan != null){
                    AppRoutes.pushTo(
                      context,
                      patientExerciseList(planId: selectedPlan,userId:widget.PatientId,),
                    );}
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(text: 'Reports'),

      body: StreamBuilder(
        stream: AppConstants.exerciseCollection
            .where('userId', isEqualTo: widget.PatientId)

            .orderBy('finishDate', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
}


