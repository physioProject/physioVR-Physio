import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:physio/Database/Database.dart';
import 'package:physio/Widget/AppButtons.dart';
import 'package:physio/Widget/AppColor.dart';
import 'package:physio/Widget/AppConstants.dart';
import 'package:physio/Widget/AppDropList.dart';
import 'package:physio/Widget/AppLoading.dart';
import 'package:physio/Widget/AppMessage.dart';
import 'package:physio/Widget/AppTextFields.dart';

import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../../Widget/AppBar.dart';

class Repeat extends StatefulWidget {
  final String exerciseId;
  final String patientId;


  Repeat({required this.exerciseId,required this.patientId});

  @override
  State<Repeat> createState() => _RepeatState();
}

class _RepeatState extends State<Repeat> {

  GlobalKey<FormState> addKey = GlobalKey();
  String? selectedExercise;
  TextEditingController startDateController = TextEditingController();
  TextEditingController finishDateController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController PlanController = TextEditingController();

  List<MultiSelectItem<Object?>> convertToMultiSelectItems(List<String> listItem) {
    return listItem.map((item) => MultiSelectItem<Object?>(item, item)).toList();}

  @override
  void initState() {
    super.initState();
    fetchExerciseDetails();
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    startDateController.text = dateFormat.format(DateTime.now());
  }

  void fetchExerciseDetails() async {
    try {
      var exerciseDetails = await Database.getExerciseDetails(widget.exerciseId,widget.patientId);
      if (exerciseDetails != null) {
        setState(() {

          finishDateController.text = exerciseDetails['finishDate'];
          durationController.text = exerciseDetails['duration'];
          PlanController.text = exerciseDetails['planName'];
          selectedExercise = exerciseDetails['exercise'];
        });
      }
    } catch (e) {
      print('Error fetching exercise details: $e');
    }
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
      appBar: AppBarWidget(text:   'Repeat Plan',

      ),
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
                labelText: 'start date',
                obscureText: false,
                enable: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Start Date is required';
                  }
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
                    firstDate: DateTime(2000),
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
                      setState(() {
                        finishDateController.text =
                            DateFormat('yyyy-MM-dd').format(selectedDate);
                        calculateDuration();
                      });
                    }
                  });
                },
                labelText: 'Finish Date',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Finish Date is required';
                  }
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
                controller: durationController,
                labelText: 'Duration (days)',
                obscureText: false,
                enable: false,
                validator: (v) {
                  if (v == null) {
                    return 'Duration is required';
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: 10.h,
              ),
              // Removed AppDropList widget
              SizedBox(
                height: 10.h,
              ),IgnorePointer(
    ignoring: true,
    child: GestureDetector(
    child: MultiSelectDialogField(

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
                    print('selectedCondition: $selectedExercise');
                  },
                  buttonText: Text('Select exercise'),
                  title: Text('Select exercise'),
                  initialValue: selectedExercise?.split(", ")?.where((item) => item != null).map<Object?>((e) => e).toList() ?? [],
                  searchable: true,
                  selectedItemsTextStyle: TextStyle(fontSize: 14.0, color: Colors.black),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    color: Colors.white,
                  ),
                  chipDisplay: MultiSelectChipDisplay(
                    chipColor: Colors.white,
                    textStyle: TextStyle(color: Colors.black),
                  ),
                  buttonIcon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black,
                  ),

                ),
              ),),
              SizedBox(
                height: 10.h,
              ),
              AppButtons(
                text: AppMessage.repeat,
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
                        userId:widget.patientId
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






