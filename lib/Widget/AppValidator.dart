import 'package:email_validator/email_validator.dart';
import 'package:physio/Widget/AppMessage.dart';

class AppValidator {
//valid empty data============================================================
  static String? validatorEmpty(v) {
    if (v.isEmpty || v == null) {
      return AppMessage.mandatoryTx ;
    } else {
      return null;
    }
  }

//valid name data============================================================
  static String? validatorName(name) {
    final nameRegExp = RegExp(r"^\s*([A-Za-z\s]{2,10})$");
    if (name.isEmpty) {
      return AppMessage.mandatoryTx ;
    }
    if (nameRegExp.hasMatch(name) == false) {
      return AppMessage.invalidName ;
    } else {
      return null;
    }
  }

  //valid email=============================================================
  static String? validatorEmail(email) {
    if (email.isEmpty) {
      return AppMessage.mandatoryTx ;
    }

    if (EmailValidator.validate(email.trim()) == false) {
      return AppMessage.invalidEmail ;
    }
    return null;
  }


//valid Password data==============================================================
  static String? validatorPassword(pass) {
    if (pass.isEmpty) {
      return AppMessage.mandatoryTx ;
    }
    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(pass)) {
      return 'Password must contain at least one uppercase letter';
    }
    // Check for at least one digit
    if (!RegExp(r'\d').hasMatch(pass)) {
      return 'Password must contain at least one digit';
    }
    // Check for at least one special character
    if (!RegExp(r'[!@#$%^&*(),_ -.?":{}|<>]').hasMatch(pass)) {
      return 'Password must contain at least one special character';
    }

    if (pass.length < 8) {
      return AppMessage.invalidPassword ;
    } else {
      return null;
    }
  }

//valid Phone data============================================================
  static String? validatorPhone(phone) {
    final phoneRegExp = RegExp(r"^\s*[0-9]{10}$");
    if (phone.trim().isEmpty) {
      return AppMessage.mandatoryTx ;
    }
    if (phoneRegExp.hasMatch(phone) == false ||
        phone.startsWith('05') == false) {
      return AppMessage.invalidPhone;
    }
    return null;
  }
  //valid patient count
  static String? validatorPatientCount(count) {
    final countRegExp = RegExp(r"^\d+$");
    if (count.isEmpty) {
      return AppMessage.mandatoryTx;
    }
    if (countRegExp.hasMatch(count) == false) {
      return AppMessage.invalidPatientCount;
    } else {
      return null;
    }
  }
}
