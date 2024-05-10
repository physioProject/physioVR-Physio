import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
class ViewPatientPlan extends StatefulWidget {
  final String PatientId;

  const ViewPatientPlan({Key? key, required this.PatientId, }) : super(key: key);

  @override
  State<ViewPatientPlan> createState() => _ViewPatientPlanState();
}
class _ViewPatientPlanState extends State<ViewPatientPlan> {
  late ImageProvider exerciseImg = AssetImage(AppImage.plan);

  Future<void> deleteExercise(String documentId) async {
    try {
      await AppConstants.exerciseCollection.doc(documentId).delete();
    } catch (e) {
      print('Error deleting exercise: $e');
    }
  }

  Future<void> showDeleteConfirmationDialog(String documentId) async {
    AppLoading.show(
      context,
      'Delete exercise',
      'Do you want to delete this exercise for this patient?',
      showButtom: true,
      noFunction: () {

      },
      yesFunction: () async {
        Navigator.pop(context);
        await deleteExercise(documentId);
      },
    );
  }

  void navigateToUpdateExercise(String documentId, String patientId) {
    AppRoutes.pushTo(
        context, UpdateExercise(exerciseId: documentId, patientId: patientId,));
  }

  Future<void> navigateToRepeat(String documentId, String patientId) async {
    try {
      // Retrieve the existing exercise data
      DocumentSnapshot exerciseSnapshot = await AppConstants.exerciseCollection.doc(documentId).get();
      Map<String, dynamic> exerciseData = exerciseSnapshot.data() as Map<String, dynamic>;

      // Check if there are any existing exercises with the same start date and exercise
      QuerySnapshot snapshot = await AppConstants.exerciseCollection
          .where('userId', isEqualTo: patientId)

          .where('exercise', isEqualTo: exerciseData['exercise'])
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Check if the existing exercise is finished
        bool isExistingExerciseFinished = false;
        try {
          DateTime finishDate = DateTime.parse(snapshot.docs.first['finishDate'].toString());
          isExistingExerciseFinished = finishDate.isBefore(DateTime.now());
        } catch (e) {
          print('Error parsing finishDate: $e');
        }

        if (!isExistingExerciseFinished) {
          // Display a message if there is an active exercise with the same start date
          AppLoading.show(
            context,
            'Repeat Exercise',
            'You already have an active plan with the same exercise list. Please complete the existing plan before repeating.',
          );
        } else {
          // Navigate to the Repeat screen
          AppRoutes.pushTo(context, Repeat(exerciseId: documentId, patientId: patientId));
        }
      } else {
        // Navigate to the Repeat screen
        AppRoutes.pushTo(context, Repeat(exerciseId: documentId, patientId: patientId));
      }
    } catch (e, stackTrace) {
      print('Error checking existing exercises: $e');
      print('Stack trace: $stackTrace');
      // Display an error message if something went wrong
      AppLoading.show(
        context,
        'Error',
        'An error occurred while checking for existing exercises. Please try again later.',
      );
    }
  }



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
                  trailing: isExerciseFinished ? SizedBox(
                    width: 90,
                    height: 30,
                    child: AppButtons(
                      onPressed: () {
                        navigateToRepeat(documentId,widget.PatientId);

                      },
                      text: 'Repeat',
                      bagColor: Colors.green,
                    ),
                  ) : InkWell(
                    onTap: () {
                      showDeleteConfirmationDialog(documentId);
                    },
                    child: Icon(
                      AppIcons.delete,
                      size: 30.spMin,
                      color: AppColor.errorColor,
                    ),
                  ),
                  title: InkWell(
                    onTap: () {
                      navigateToUpdateExercise(documentId,widget.PatientId);
                    },
                    child: Column(
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
      appBar: AppBarWidget(text: AppMessage.PatientPlan),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.iconColor,
        elevation: 10,
        child: Icon(AppIcons.add
        ),
        onPressed: () {
          AppRoutes.pushTo(context, AddNewExercise(PatientId: widget.PatientId));
        },
      ),
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

