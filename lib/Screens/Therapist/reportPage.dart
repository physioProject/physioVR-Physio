import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import '../../../Widget/AppBar.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:physio/Screens/Patient/patientExercise.dart';
import '../../Database/Database.dart';
import '../../Widget/AppButtons.dart';
import '../../Widget/AppIcons.dart';
import '../../Widget/AppImage.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:physio/Screens/Therapist/TherapistHome.dart';
import '../../../Widget/AppBar.dart';
import '../../../Widget/AppMessage.dart';
import '../../Widget/AppColor.dart';
import '../../Widget/AppConstants.dart';
import '../../Widget/AppPopUpMen.dart';
import '../../Widget/AppRoutes.dart';
import '../../Widget/AppSize.dart';
import '../../Widget/AppText.dart';
import '../../Widget/AppTextFields.dart';
import '../../Widget/AppValidator.dart';
import '../../Widget/GeneralWidget.dart';
import '../Account/Login.dart';
import '../../../Widget/AppMessage.dart';
import 'package:pdf/pdf.dart' as pw;
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import '../Therapist/ViewPatients.dart';
import '../Therapist/ViewPatientReport.dart';
import 'package:pdf/widgets.dart' as pw;

class reportPage extends StatefulWidget {
  final String planId;
  final String userId;
  final String level;
  final String exercise;
  final List<String> dates;


  const reportPage({Key? key, required this.planId, required this.userId,required this.level,required this.exercise, required this.dates}) : super(key: key);

  @override
  State<reportPage> createState() => _reportPageState();
}


class _reportPageState extends State<reportPage> {
  Set<String> displayedDates = Set<String>();

  String planName = '';
  int total = 0;


  @override
  void initState() {
    super.initState();
    fetchPlanName();
  }

  Future<void> fetchPlanName() async {
    final planSnapshot = await FirebaseFirestore.instance.collection('plan')
        .doc(widget.planId)
        .get();
    final planData = planSnapshot.data() as Map<String, dynamic>?;
    if (planData != null) {
      setState(() {
        planName = planData['planName'];
      });
    }
  }

  Future<String> fetchPatientName(String userId) async {
    print('Fetching patient name for userId: $userId');
    try {
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('userId', isEqualTo: userId)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        final userData = userSnapshot.docs.first.data();
        if (userData != null && userData.containsKey('firstName') && userData.containsKey('lastName')) {
          final firstName = userData['firstName'];
          final lastName = userData['lastName'];
          final patientName = '$firstName $lastName';
          print('Patient name retrieved: $patientName');
          return patientName;
        } else {
          print('User data incomplete for userId: $userId');
          return '';
        }
      } else {
        print('User document not found for userId: $userId');
        return '';
      }
    } catch (e) {
      print('Error fetching user data for userId: $userId');
      print(e.toString());
      return '';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(text: 'Report Page'),
        body: FutureBuilder<String>(
        future: fetchPatientName(widget.userId),
    builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
    return Center(child: Text('Error: ${snapshot.error}'));
    } else {
     // print("Snapshot data: ${snapshot.data}"); testing
    final patientName = snapshot.data ?? '';
    return StreamBuilder<DocumentSnapshot>(
    stream: FirebaseFirestore.instance.collection('reports').doc(
    widget.userId).snapshots(),
    builder: (context, snapshot) {
    if (snapshot.hasError) {
    return Center(child: Text('${snapshot.error}'));
    }

    if (snapshot.connectionState == ConnectionState.waiting) {
    return Center(child: CircularProgressIndicator());
    }

    final reportData = snapshot.data?.data() as Map<String, dynamic>?;

    if (reportData == null || reportData.isEmpty) {
    return Center(
    child: Text(
    'No data',
    style: TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    ),
    ),
    );
    }

    final exercises = reportData.entries
        .where((entry) => entry.key != 'score')
        .map((entry) => entry.value)
        .toList();

    if (exercises.isEmpty) {
    return Center(
    child: Text(
    'No exercises found',
    style: TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    ),
    ),
    );
    }

    final filteredExercises = exercises.where((score) {
    return score['planId'] == widget.planId &&
    score['exercise'] == widget.exercise &&
    score['level'] == widget.level && widget.dates.contains(score['date']);

    }).toList();

    if (filteredExercises.isEmpty) {
    return Center(
    child: Text(
    'No data found for the specified exercise',
    style: TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    ),
    ),
    );
    }

    final scores = filteredExercises.map((exerciseData) => int.parse(exerciseData['score'])).toList();
    final scoresString = scores.join(', ');
    String imagePath = '';

    if (filteredExercises.isNotEmpty) {
      final totalScores = scores.reduce((value, element) => value + element);
      final score = totalScores / filteredExercises.length.round();
      final int scoreInt = score.round();
      final String scoreS = scoreInt.toString();

      if (widget.level == '1') {
    if (score <= 200) {
    imagePath = AppImage.Below;
    } else if (score > 200 && score <= 300) {
    imagePath = AppImage.NeedsImp;
    } else if (score > 300 && score <= 400) {
    imagePath = AppImage.average;
    } else if (score > 400 && score <= 500) {
    imagePath = AppImage.aboveaverage;
    } else {
    imagePath = AppImage.exc;
    }
    } else if (widget.level == '2') {
    if (score <= 200) {
    imagePath = AppImage.Below;
    } else if (score > 200 && score <= 500) {
    imagePath = AppImage.NeedsImp;
    } else if (score > 500 && score <= 700) {
    imagePath = AppImage.average;
    } else if (score > 700 && score <= 900) {
    imagePath = AppImage.aboveaverage;
    } else {
    imagePath = AppImage.exc;
    }
    }

    return SingleChildScrollView(
    child: Center(
    child: Padding(
    padding: EdgeInsets.symmetric(horizontal: MediaQuery
        .of(context)
        .size
        .width * 0.1),
    child: Column(
    children: [
    if (imagePath.isNotEmpty) ...[
    CircleAvatar(
    radius: 200,
    backgroundColor: Colors.transparent,
    child: ClipOval(
    child: Image(
    image: AssetImage(imagePath),
    fit: BoxFit.cover,
    width: 700,
    height: 700,
    ),
    ),
    ),
    SizedBox(height: 0),
    ],
    AppTextFields(
    controller: TextEditingController(text: planName),
    labelText: 'Plan Name',
    validator: (v) => AppValidator.validatorName(v),
    obscureText: false,
    enable: false,
    ),
    SizedBox(height: 10.h),
    AppTextFields(
    controller: TextEditingController(text: widget
        .exercise),
    labelText: 'Exercise Type',
    validator: (v) => AppValidator.validatorName(v),
    obscureText: false,
    enable: false,
    ),
    SizedBox(height: 10.h),
    AppTextFields(
      controller: TextEditingController(text: widget.level),
      labelText: 'Exercise Level',
      validator: (v) => AppValidator.validatorEmpty(v),
      obscureText: false,
      enable: false,
    ), SizedBox(height: 10.h),
      AppTextFields(
        labelText: 'Exercise Date',
        validator: (v) => AppValidator.validatorEmpty(v),
        obscureText: false,
        enable: false,
        controller: TextEditingController(
          text: widget.dates.isEmpty
              ? ''
              : widget.dates.length > 1
              ? '${widget.dates.first} - ${widget.dates.last}'
              : widget.dates.first,
        ),
        onTap: () {
          if (widget.dates.isNotEmpty) {
            final smallestDate = widget.dates.reduce((a, b) => a.compareTo(b) < 0 ? a : b);
            final largestDate = widget.dates.reduce((a, b) => a.compareTo(b) > 0 ? a : b);

            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Date Range'),
                content: Text('Start: $smallestDate\nEnd: $largestDate'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          }
        },
      )

      ,SizedBox(height: 10.h),
      AppTextFields(
        controller: TextEditingController(
            text: filteredExercises.length.toString()),
        labelText: 'Total Exercises',
        validator: (v) => AppValidator.validatorEmpty(v),
        obscureText: false,
        enable: false,
      ),
      SizedBox(height: 10.h),
      AppTextFields(
        controller: TextEditingController(text: scoreS),
        labelText: 'AVG Score',
        validator: (v) => AppValidator.validatorEmpty(v),
        obscureText: false,
        enable: false,
      ),
      SizedBox(height: 20.h),
      ElevatedButton(
        onPressed: () async {
          final patientName = await fetchPatientName(widget.userId);
          print('Patient Name: $patientName');

          _shareAsPdf(scoreS, filteredExercises.length, patientName,widget.dates);
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              AppColor.black),  minimumSize: MaterialStateProperty.all(Size(320, 50)), //
        ),
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Share File ' ,style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,)),
            Icon(AppIcons.share),
          ],
        ),
      ),
    ],
    ),
    ),
    ),
    );
    }
    return SizedBox();


    },
    );
    }
    },
        ),
    );
  }


    Future<void> _shareAsPdf(String scoresS, int total, String patientName,  List<String> dates) async {
    final pdf = pw.Document();

  
    final Uint8List imageData = (await rootBundle.load('assets/image/pdf.png'))
        .buffer
        .asUint8List();

    // Define font styles
    final pw.TextStyle titleStyle = pw.TextStyle(
      fontSize: 20,
      fontWeight: pw.FontWeight.bold,
    );
    final pw.TextStyle normalStyle = pw.TextStyle(fontSize: 16);
    final pw.TextStyle performanceStyle = pw.TextStyle(
      fontSize: 16,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.blue,
    );


    String performanceText = '';
    final score = int.parse(scoresS.split(',').first);
    if (widget.level == '1') {
      if (score <= 200) {
        performanceText = 'Below average';
      } else if (score > 200 && score <= 300) {
        performanceText = 'Needs improvement';
      } else if (score > 300 && score <= 400) {
        performanceText = 'Average';
      } else if (score > 400 && score <= 500) {
        performanceText = 'Above average';
      } else {
        performanceText = 'Exceptional';
      }
    } else if (widget.level == '2') {
      if (score <= 200) {
        performanceText = 'Below average';
      } else if (score > 200 && score <= 500) {
        performanceText = 'Needs improvement';
      } else if (score > 500 && score <= 700) {
        performanceText = 'Average';
      } else if (score > 700 && score <= 900) {
        performanceText = 'Above average';
      } else {
        performanceText = 'Exceptional';
      }
    }


    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              pw.Positioned.fill(
                child: pw.Image(
                  pw.MemoryImage(imageData),
                  fit: pw.BoxFit.cover,
                ),
              ),
              pw.Center(
                child: pw.Container(
                  alignment: pw.Alignment.center,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      // Title
                      pw.Text('Summary', style: titleStyle),
                      pw.SizedBox(height: 20),


                      pw.Text('Patient Name: $patientName', style: normalStyle),
                      pw.Text('Plan Name: ${planName}', style: normalStyle),
                      pw.Text('Exercise Type: ${widget.exercise}', style: normalStyle),
                      pw.Text('Exercise Level: ${widget.level}', style: normalStyle),
                  pw.Text('Date: ${dates.length > 1 ? "${dates.first} - ${dates.last}" : dates.first}',
                    style: normalStyle,),
                      pw.Text('Total: ${total}', style: normalStyle),
                      pw.Text('Scores: ${scoresS}', style: normalStyle),
                      pw.SizedBox(height: 10),
                      pw.Text('Patient\'s Performance: ${performanceText}',
                          style: performanceStyle),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    final bytes = await pdf.save();
    Printing.sharePdf(bytes: bytes, filename: 'patient_report.pdf');
  }}
