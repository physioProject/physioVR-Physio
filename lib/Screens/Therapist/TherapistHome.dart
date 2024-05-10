import 'package:flutter/material.dart';
import 'package:physio/Database/Database.dart';
import 'package:physio/Widget/AppButtons.dart';

import '../../Widget/AppColor.dart';
import '../../Widget/AppIcons.dart';
import '../../Widget/AppMessage.dart';
import '../../Widget/AppRoutes.dart';
import '../Account/Login.dart';

import 'package:physio/Screens/Therapist/ViewPatients.dart';
import 'package:physio/Screens/Therapist/ViewPatientInfo.dart';
import 'package:physio/Screens/Therapist/ViewPatientPlan.dart';
import 'package:physio/Screens/Therapist/ViewPatientReport.dart';


class TherapistHome extends StatefulWidget {
  final String PatientId;
  const TherapistHome({Key? key, required this.PatientId}) : super(key: key);

  @override
  State<TherapistHome> createState() => _TherapistHomeState();
}

class _TherapistHomeState extends State<TherapistHome> {
  int selectedIndex = 0;
  late String SelectedUser;
  PageController? pageController;
  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: selectedIndex);
    SelectedUser=widget.PatientId;

  } @override
  Widget build(BuildContext context) {
  List<Widget> page = [ViewPatientInfo(PatientId:widget.PatientId), ViewPatientPlan(PatientId:widget.PatientId), ViewPatientReport(PatientId:widget.PatientId)];


    return Scaffold(

      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: page,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColor.iconColor,
        selectedFontSize: 14,
        selectedItemColor: AppColor.white,
        unselectedItemColor: Colors.grey[500],
        unselectedFontSize: 11,
        currentIndex: selectedIndex,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(AppIcons.managePatient),
            label: AppMessage.PatientInfo,
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.manageTherapist),
            label: AppMessage.PatientPlan,
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.manageAccounts),
            label: AppMessage.PatientReport,
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    pageController?.animateToPage(selectedIndex,
        duration: const Duration(milliseconds: 400), curve: Curves.easeInCirc);
  }
}

