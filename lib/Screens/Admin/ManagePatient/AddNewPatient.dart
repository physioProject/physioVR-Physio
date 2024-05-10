import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:physio/Widget/generalWidget.dart';
import '../../../Database/Database.dart';
import '../../../Widget/AppBar.dart';
import '../../../Widget/AppButtons.dart';
import '../../../Widget/AppColor.dart';
import '../../../Widget/AppConstants.dart';
import '../../../Widget/AppDropList.dart';
import '../../../Widget/AppLoading.dart';
import '../../../Widget/AppMessage.dart';
import '../../../Widget/AppTextFields.dart';
import '../../../Widget/AppValidator.dart';

class AddNewPatient extends StatefulWidget {
  const AddNewPatient({Key? key}) : super(key: key);

  @override
  State<AddNewPatient> createState() => _AddNewPatientState();
}

class _AddNewPatientState extends State<AddNewPatient> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailPathController = TextEditingController();
  DateTime? selectedDateOfBirth;
  GlobalKey<FormState> addKey = GlobalKey();
  String? selectedCondition;
  String? generatedPassword;
  String? docId;
  List<MultiSelectItem<Object?>> convertToMultiSelectItems(List<String> listItem) {
    return listItem.map((item) => MultiSelectItem<Object?>(item, item)).toList();
  }
  static const String dateOfBirthLabel = 'Date of Birth';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(text: AppMessage.addPatient),
      body: Form(
        key: addKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: ListView(
            children: [
              SizedBox(
                height: 20.h,
              ),
              //==============================first name===============================================================
              AppTextFields(
                controller: firstNameController,
                labelText: AppMessage.firstName,
                validator: (v) => AppValidator.validatorName(v),
                obscureText: false,
              ),
              SizedBox(
                height: 10.h,
              ),
              //==============================last name===============================================================
              AppTextFields(
                controller: lastNameController,
                labelText: AppMessage.lastName,
                validator: (v) => AppValidator.validatorName(v),
                obscureText: false,
              ),
              SizedBox(
                height: 10.h,
              ),
              //==============================email name===============================================================
              AppTextFields(
                controller: emailPathController,
                labelText: AppMessage.emailTx,
                validator: (v) => AppValidator.validatorEmail(v),
                obscureText: false,
              ),
              SizedBox(
                height: 10.h,
              ),
              //==============================phone number===============================================================
              AppTextFields(
                controller: phoneController,
                labelText: AppMessage.phoneTx,
                validator: (v) => AppValidator.validatorPhone(v),
                obscureText: false,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 10.h,
              ),
              //==============================Date of Birth & condition=============================
              AppTextFields(
                controller: TextEditingController(
                  text: selectedDateOfBirth != null
                      ? DateFormat('yyyy-MM-dd').format(selectedDateOfBirth!)
                      : '',
                ),
                labelText: dateOfBirthLabel,
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: ThemeData.dark().copyWith(
                          primaryColor: Colors.black,
                        ),
                        child: child!,
                      );
                    },
                  ).then((selectedDate) {
                    if (selectedDate != null) {
                      setState(() {
                        this.selectedDateOfBirth = selectedDate;
                      });
                    }
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppMessage.mandatoryTx;
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10.h,
              ),
          MultiSelectDialogField(
            items: convertToMultiSelectItems(AppConstants.conditionMenu),
            validator: (v) {
              if (v == null) {
                return AppMessage.mandatoryTx;
              } else {
                return null;
              }
            },
            onConfirm: (List<Object?>? selectedItems) {
              setState(() {
                selectedCondition = selectedItems?.cast<String>().join(", ");
              });
              print('selectedCondition: $selectedCondition');
            },
            buttonText: Text('Select Condition'),
            title: Text('Select Condition'),
            initialValue: selectedCondition?.split(", ")?.where((item) => item != null).map<Object?>((e) => e).toList() ?? [],
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

              //==============================Add Button===============================================================
              AppButtons(
                text: AppMessage.add,
                bagColor: AppColor.iconColor,
                onPressed: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (addKey.currentState?.validate() == true) {
                    generatedPassword = AppWidget.randomUpper(1) +
                        AppWidget.randomLower(1) +
                        AppWidget.randomCode(1) +
                        AppWidget.randomNumber(5);
                    AppLoading.show(context, '', 'lode');
                    Database.patientSingUp(
                      firstName: firstNameController.text,
                      lastName: lastNameController.text,
                      email: emailPathController.text,
                      password: generatedPassword!,
                      phone: phoneController.text,
                      dateOfBirth: selectedDateOfBirth,
                      condition: selectedCondition!,
                    ).then((v) {
                      if (v == "done") {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        AppLoading.show(
                            context, AppMessage.add, AppMessage.done);
                      } else if (v == 'email-already-in-use') {
                        Navigator.pop(context);
                        AppLoading.show(context, 'inactive User',
                            AppMessage.emailFoundActiveUser, showButtom: true,
                            noFunction: () {
                              Navigator.pop(context);
                            }, yesFunction: () async {
                              await AppConstants.userCollection
                                  .where('email',
                                  isEqualTo: emailPathController.text)
                                  .get()
                                  .then((value) {
                                for (var element in value.docs) {
                                  docId = element.id;
                                  setState(() {});
                                }
                              });

                              await Database.updateActiveUser(
                                  docId: docId!, activeUser: true);
                              print(
                                  'objectobjectobjectobjectobjectobjectobjectobjectobjectobjectobjectobject');
                              Navigator.pop(context);
                              Navigator.pop(context);
                            });
                      } else {
                        Navigator.pop(context);
                        AppLoading.show(
                            context, AppMessage.add, AppMessage.error);
                      }
                    });
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
