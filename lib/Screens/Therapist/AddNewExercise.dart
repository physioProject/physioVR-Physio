import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:physio/Screens/Therapist/ViewPatientPlan.dart';

import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:physio/Widget/AppTextFields.dart';
import '../../../Widget/AppBar.dart';
import '../../../Database/Database.dart';
import '../../../Widget/AppMessage.dart';
import '../../Widget/AppButtons.dart';
import '../../Widget/AppColor.dart';
import '../../Widget/AppConstants.dart';
import '../../Widget/AppDropList.dart';
import '../../Widget/AppLoading.dart';


class AddNewExercise extends StatefulWidget {
  final String PatientId;

  const AddNewExercise({Key? key, required this.PatientId}) : super(key: key);

  @override
  State<AddNewExercise> createState() => _AddNewExerciseState();
}

class _AddNewExerciseState extends State<AddNewExercise> {
  GlobalKey<FormState> addKey = GlobalKey();
  String? selectedExercise;
  TextEditingController startDateController = TextEditingController();
  TextEditingController finishDateController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController PlanController = TextEditingController();
  List<MultiSelectItem<Object?>> convertToMultiSelectItems(List<String> listItem) {
    return listItem.map((item) => MultiSelectItem<Object?>(item, item)).toList();
  }
  @override
  void dispose() {
    startDateController.dispose();
    finishDateController.dispose();
    durationController.dispose();
    super.dispose();
  }
  void calculateDuration() {
    if (startDateController.text.isNotEmpty && finishDateController.text.isNotEmpty) {
      DateTime startDate = DateTime.parse(startDateController.text);
      DateTime finishDate = DateTime.parse(finishDateController.text);
      Duration duration = finishDate.difference(startDate);
      durationController.text = duration.inDays.toString();
    } else {
      durationController.text = '';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(text: AppMessage.AddingPlan),
      body: Form(
        key: addKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: ListView(
            children: [
              SizedBox(
                height: 20.h,
              ),

              AppTextFields(
                controller: startDateController,

                onTap: () {

    showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(2100),
    builder: (BuildContext context, Widget? child) {
    return Theme(
                        data: ThemeData(

                          colorScheme: ColorScheme.light().copyWith(
                            primary: Colors.black,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  ).then((selectedDate) {
                    if (selectedDate != null) {
    DateTime selectedEndDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    DateTime currentDateTime = DateTime.now();
    DateTime currentDate = DateTime(currentDateTime.year, currentDateTime.month, currentDateTime.day);
    if (selectedEndDate.isBefore(currentDate)) {
    return 'start date must be after current date';
    } else {
                      setState(() {
                        startDateController.text =
                            DateFormat('yyyy-MM-dd').format(selectedDate);
                        calculateDuration();
                      });
                    }
                  }});
                },
                labelText: AppMessage.startDate,

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppMessage.mandatoryTx;
                  }
                  // Check if start date is before finish date
                  if (finishDateController.text.isNotEmpty) {
                    DateTime startDate = DateTime.parse(value);
                    DateTime finishDate = DateTime.parse(finishDateController.text);
                    if (startDate.isAfter(finishDate)) {
                      return 'Start date must be before finish date';
                    }
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10.h,
              ),
              AppTextFields(
    controller: finishDateController,
    onTap: () {
    showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(2100),
    builder: (BuildContext context, Widget? child) {
    return Theme(
    data: ThemeData(
    colorScheme: ColorScheme.light().copyWith(
    primary: Colors.black,
    ),
    ),
    child: child!,
    );
    },
    ).then((selectedDate) {
    if (selectedDate != null) {
    DateTime selectedStartDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    DateTime currentDateTime = DateTime.now();
    DateTime currentDate = DateTime(currentDateTime.year, currentDateTime.month, currentDateTime.day);
    if (selectedStartDate.isBefore(currentDate)) {
      return 'Finish date must be after current date';
    } else {
                      setState(() {
                        finishDateController.text =
                            DateFormat('yyyy-MM-dd').format(selectedDate);
                        calculateDuration();
                      });
                    }
                  }});
                },

                labelText: AppMessage.finishDate,

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppMessage.mandatoryTx;
                  }
                  // Check if finish date is after start date
                  if (startDateController.text.isNotEmpty) {
                    DateTime startDate = DateTime.parse(startDateController.text);
                    DateTime finishDate = DateTime.parse(value);
                    if (finishDate.isBefore(startDate)) {
                      return 'Finish date must be after start date';
                    }
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10.h,
              ),
    AppTextFields(
      validator: (v) {
        if (v == null) {
          return AppMessage.mandatoryTx;
        } else {
          return null;
        }
      },

      obscureText: false,
      enable:false,

     controller: durationController, labelText: '${AppMessage.duration} days')
         , SizedBox(
          height: 10.h,
        ),
          MultiSelectDialogField(
                items: convertToMultiSelectItems(AppConstants.ExerciseList),
                validator: (v) {
                  if (v == null) {
                    return AppMessage.mandatoryTx;
                  } else {
                    return null;
                  }
                },
                onConfirm: (List<Object?>? selectedItems) {
                  setState(() {
                    selectedExercise = selectedItems?.cast<String>().join(", ");
                  });
                  print('selectedexercise: $selectedExercise');
                },
                buttonText:Text('selectedExercise'),
                title: Text('Select Exercise'),
                initialValue: selectedExercise?.split(", ")?.where((item) => item != null).map<Object?>((e) => e).toList() ?? [],
                searchable: true,
                selectedItemsTextStyle: TextStyle(fontSize: 14.0 ,color: Colors.black),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),

                  color: Colors.white,
                ),chipDisplay: MultiSelectChipDisplay(chipColor: Colors.white,textStyle: TextStyle(color: Colors.black)),
                buttonIcon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black,
                ),
              ),
    SizedBox(
    height: 10.h,
    ),
      AppButtons(
        text: AppMessage.add,
        bagColor: AppColor.iconColor,
        onPressed: () async {
          FocusManager.instance.primaryFocus?.unfocus();
          if (addKey.currentState?.validate() == true) {
            // add operation
            Database.AddNewExercise(

              exercise: selectedExercise!,
startDate:startDateController.text,
              finishDate: finishDateController.text,
              duration:durationController.text,
              userId:widget.PatientId
            ).then((v) {
              if (v == "done") {
                Navigator.pop(context);
                AppLoading.show(context, AppMessage.add, AppMessage.done);

              } else {
                Navigator.pop(context);
                AppLoading.show(context, AppMessage.add, AppMessage.error);
              }
            });
          }
        },
      ),
          ],
             ),
            ),
          ),
        );
       }
     }



