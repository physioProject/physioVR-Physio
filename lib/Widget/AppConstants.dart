import 'package:cloud_firestore/cloud_firestore.dart';

class AppConstants {
  static CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  static CollectionReference exerciseCollection =
  FirebaseFirestore.instance.collection('plan');

  static String typeIsTherapist = 'therapist';
  static String typeIsPatient = 'patient';
  static String typeIsAdmin = 'admin';

  static List<String> conditionMenu = [
    'Thoracic outlet syndrome',
    'Cervical disc bulge',
    'Frozen shoulder',
    'Tennis elbow',
    'Golfer’s elbow',
    'Carpel tunnel',
    'Shoulder impingement syndrome',
    'Shoulder recurrent dislocation'
  ];
  static List<String> ExerciseList = [
    'Shoulder front raise level1',
    'Shoulder front raise level2',
    'Shoulder side raise level1',
    'Shoulder side raise level2',
    'Curl level1',
    'Curl level2'
  ];
  static List<String> typeMenu = ['admin', 'patient', 'therapist'];
}

