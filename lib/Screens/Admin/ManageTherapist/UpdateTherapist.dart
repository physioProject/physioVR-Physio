
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Database/Database.dart';
import '../../../Widget/AppBar.dart';
import '../../../Widget/AppButtons.dart';
import '../../../Widget/AppColor.dart';
import '../../../Widget/AppConstants.dart';

import '../../../Widget/AppLoading.dart';
import '../../../Widget/AppMessage.dart';
import '../../../Widget/AppTextFields.dart';
import '../../../Widget/AppValidator.dart';

class UpdateTherapist extends StatefulWidget {
  final String docId;
  final String firstName;
  final String lastName;
  final String phone;
  final String email;

  final String userId;
  const UpdateTherapist(
      {Key? key,
      required this.docId,
      required this.firstName,
      required this.lastName,
      required this.phone,
      required this.email,
        required this.userId,
      })
      : super(key: key);



  @override
  State<UpdateTherapist> createState() => _UpdatePatientState();
}

class _UpdatePatientState extends State<UpdateTherapist> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailPathController = TextEditingController();
  TextEditingController patientCountController = TextEditingController();
  GlobalKey<FormState> updateKey = GlobalKey();
int? patientCount;
  @override
  void initState() {
    // TODO: implement initState
    firstNameController.text = widget.firstName;
    lastNameController.text = widget.lastName;
    emailPathController.text = widget.email;
    phoneController.text = widget.phone;


      super.initState();
      fetchPatientCount().then((count) {
        setState(() {
          patientCount = count;
          patientCountController.text=count.toString();

      });

  });}
  //==============================Count Number of patient===============================================================
  Future<int> fetchPatientCount() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('therapistId', isEqualTo: widget.userId)
       .where('activeUser', isEqualTo: true)
        .get();
    return querySnapshot.docs.length;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(text: AppMessage.updateTherapist),
      body: Form(
        key: updateKey,
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
                enable: false,
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
                  keyboardType: TextInputType.number),
              SizedBox(
                height: 10.h,
              ),
//==============================Number of Patients===============================================================
              AppTextFields(
                controller: patientCountController,
                labelText: AppMessage.noPatient,
                validator: (v) => AppValidator.validatorPatientCount(v),
                obscureText: false,
                enable: false,
              ),
              SizedBox(
                height: 10.h,
              ),
//==============================Add Button===============================================================
              AppButtons(
                text: AppMessage.update,
                bagColor: AppColor.iconColor,
                onPressed: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (updateKey.currentState?.validate() == true) {
                    AppLoading.show(context, '', 'lode');
                    Database.updateTherapist(
                      firstName: firstNameController.text,
                      lastName: lastNameController.text,
                      phone: phoneController.text,
                      docId: widget.docId,
                      therapistId:widget.userId,
                    ).then((v) {
                      
                      if (v == "done") {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        AppLoading.show(
                            context, AppMessage.update, AppMessage.done);
                      } else {
                        Navigator.pop(context);
                        AppLoading.show(
                            context, AppMessage.update, AppMessage.error);
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
