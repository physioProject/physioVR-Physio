import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:physio/Widget/AppColor.dart';
import '../../../Widget/AppBar.dart';
import '../../../Widget/AppMessage.dart';
import 'package:physio/Widget/AppLoading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Widget/AppImage.dart';
import '../../Widget/AppTextFields.dart';
import '../../Widget/AppValidator.dart';

class ViewPatientInfo extends StatefulWidget {
  final String PatientId;
  const ViewPatientInfo({Key? key,required this.PatientId}) : super(key: key);

  @override
  State<ViewPatientInfo> createState() => _ViewPatientInfoState();
}class _ViewPatientInfoState extends State<ViewPatientInfo> {
  String patientName = '';
  String patientCondition = '';
  String patientEmail = '';
  String age = '';
  late ImageProvider profileImg;
  TextEditingController nameController = TextEditingController();
  TextEditingController  ageController= TextEditingController();
  TextEditingController conditionController= TextEditingController();
  TextEditingController emailController= TextEditingController();
  @override
  void initState() {
    super.initState();
    fetchPatientData();
    profileImg = AssetImage(AppImage.pro);
  }

  Future<void> fetchPatientData() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('userId', isEqualTo: widget.PatientId)
        .get();

    setState(() {
      final document = querySnapshot.docs.first;
      patientName = '${document['firstName']} ${document['lastName']}';
      DateTime dateOfBirth = document['dateOfBirth'].toDate();
      age = _calculateAge(dateOfBirth).toString();
      patientCondition = document['condition'];
      patientEmail = document['email'];
      nameController.text=patientName;
      ageController.text=age;
      conditionController.text=patientCondition;
      emailController.text=patientEmail;
    });
  }
  //==============================calculate age===============================================================
  int _calculateAge(DateTime dateOfBirth) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - dateOfBirth.year;
    if (currentDate.month < dateOfBirth.month ||
        (currentDate.month == dateOfBirth.month &&
            currentDate.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

//==============================open email===============================================================
  void openEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: patientEmail,
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
        AppLoading.show(context,'open','could not launch email');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(text: AppMessage.PatientInfo),

      body: Center(

          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery
                  .of(context)
                  .size
                  .width * 0.1,

            ),
            child: ListView(
              children: [CircleAvatar(
                radius: 100.sp,
                child: ClipOval(
                  child: Image(
                    image: profileImg,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
                SizedBox(
                  height: 40.h,
                ), 
                
   //==============================full name===============================================================
                AppTextFields(
                  controller: nameController,
                  labelText: AppMessage.fullName,
                  validator: (v) => AppValidator.validatorName(v),
                  obscureText: false,
                  enable: false,

                ),

                SizedBox(
                  height: 10.h,
                ),
//==============================age===============================================================
                AppTextFields(
                  controller: ageController,
                  labelText: AppMessage.age,
                  validator: (v) => AppValidator.validatorEmpty(v),
                  obscureText: false,
                  enable: false,
                ),
                SizedBox(
                  height: 10.h,
                ),
//==============================condition===============================================================
                AppTextFields(
                  controller: conditionController,
                  labelText: AppMessage.condition,
                  validator: (v) => AppValidator.validatorEmpty(v),
                  obscureText: false,
                  enable: false,
                ),
                SizedBox(
                  height: 10.h,
                ),
//==============================email===============================================================
            InkWell(
              onTap: openEmail,
                child: AppTextFields(
                  controller: emailController,

                  labelText: AppMessage.emailTx,
                  validator: (v) => AppValidator.validatorEmail(v),
                  obscureText: false,
                  enable: false,
                ),),
                SizedBox(
                  height: 10.h,
                ),

              ],
            ),
          ),

      ),
    );
  }

}

