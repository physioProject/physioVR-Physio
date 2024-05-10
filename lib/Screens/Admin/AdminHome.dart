import 'package:flutter/material.dart';
import 'package:physio/Widget/AppMessage.dart';

import '../../Widget/AppColor.dart';
import '../../Widget/AppIcons.dart';
import 'ManageAccount/ManageAccount.dart';
import 'ManagePatient/ViewPatient.dart';
import 'ManageTherapist/ViewTherapist.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int selectedIndex = 0;
  PageController? pageController;
  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: selectedIndex);
  }

  List<Widget> page = [ViewPatient(), ViewTherapist(), ManageAccount()];
  @override
  Widget build(BuildContext context) {
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
            label: AppMessage.managePatient,
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.manageTherapist),
            label: AppMessage.manageTherapist,
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.manageAccounts),
            label: AppMessage.manageAccount,
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
