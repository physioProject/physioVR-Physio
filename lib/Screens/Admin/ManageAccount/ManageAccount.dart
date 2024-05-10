import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:physio/Database/Database.dart';
import 'package:physio/Widget/AppBar.dart';
import 'package:physio/Widget/AppColor.dart';
import 'package:physio/Widget/AppIcons.dart';
import 'package:physio/Widget/AppMessage.dart';
import 'package:physio/Widget/AppPopUpMen.dart';
import 'package:physio/Widget/AppRoutes.dart';
import 'package:physio/Widget/generalWidget.dart';
import 'package:physio/Screens/Account/Login.dart';
import 'package:physio/Widget/AppDropList.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:physio/Widget/AppSize.dart';
import 'package:physio/Widget/AppText.dart';
import 'package:physio/Widget/AppConstants.dart';
import '../../../Database/Database.dart';


class ManageAccount extends StatefulWidget {
  const ManageAccount({Key? key}) : super(key: key);

  @override
  State<ManageAccount> createState() => _ManageAccountState();
}

class _ManageAccountState extends State<ManageAccount> {
  List<String> therapistNames = [];
  List<String> therapistIds = [];
  Map<String, String?> selectedTherapists = {};


  @override
  void initState() {
    super.initState();
    fetchTherapistNames();
  
  }
 
  //======================= fetch Therapist Names  ======================================
  Future<void> fetchTherapistNames() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('type', isEqualTo: 'therapist')
       .where('activeUser', isEqualTo: true)
        .get();
    setState(() {
      therapistNames = querySnapshot.docs
          .map((document) => '${document['firstName']} ${document['lastName']}')
          .toList();
      therapistIds=querySnapshot.docs
          .map((document) =>'${document['userId']}') .toList();
      therapistNames.insert(0, 'undefined');
      therapistIds.insert(0, 'undefined');
    });
  }
  //======================= Build the UI  ======================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        text: AppMessage.manageAccountB,
        leading: AppPopUpMen(
          icon: CircleAvatar(
            backgroundColor: AppColor.black,
            child: Icon(AppIcons.menu),
          ),
          menuList: AppWidget.itemList(action: () {
            Database.logOut();
            AppRoutes.pushReplacementTo(context, const Login());
          }),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: AppConstants.userCollection
            .where('type', isEqualTo: AppConstants.typeIsPatient)
         .where('activeUser', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }
          if (snapshot.hasData) {
            return buildBody(context, snapshot.data!.docs);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  //======================= Build the body ======================================
  Widget buildBody(BuildContext context, List<QueryDocumentSnapshot> documents) {
    return ListView.builder(
        itemCount: documents.length,
        itemBuilder: (context, i) {
      var data = documents[i].data() as Map<String, dynamic>;
      var patientId = documents[i].id;


   //======================= Build a card for each patients ======================================
       return Padding(
         padding: EdgeInsets.symmetric(vertical: 5.h),
       child: SizedBox(
        height: 118.h,
       width: double.maxFinite,
       child: Card(
        elevation: 5,
        child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 1.h),
          child: Column(
             children: [
               ListTile(
               tileColor: AppColor.white,
                leading: InkWell(
                  child: Icon(
                    AppIcons.profile,
                     size: 45.spMin,
                             ),
                             ),
               title: AppText(
               text: '${data['firstName']} ${data['lastName']}\nTherapist Name: ${data['therapistName']}',
                 fontSize: AppSize.subTextSize,
                                          ),
                                          ),


      //======================= AppDropList configuration ======================================

                  Expanded(
                   child: SingleChildScrollView(
                     child: AppDropList(
                       listItem: therapistNames,
                       validator: (v) {
                         if (v == null) {
                           return AppMessage.mandatoryTx;
                         } else {
                           return null;
                         }
                       },

                       onChanged: (selectedItem) async {
                         setState(() {
                           selectedTherapists[patientId] = selectedItem!;
                         });
                         String result = await Database.updateTherapistName(
                           docId: patientId,
                           therapistId: therapistIds[therapistNames.indexOf(selectedItem!)],
                           therapistName: selectedItem!,
                         );
                         if (result == 'done') {
                           print('Therapist ID updated successfully');
                         } else {
                           print('Error updating therapist ID');
                         }
                       },
                       hintText: 'Therapists list',
                       dropValue: selectedTherapists[patientId],
                       isMultiSelect: false, // تم تفعيل الاختيار المتعدد
                       multiSelectSeparator: ", ", // فاصلة ومسافة بين العناصر المحددة
                     ),
                   ),
                 ),
          ],
             ),
           ),
         ),
       )));


      },
    );
  }



}


