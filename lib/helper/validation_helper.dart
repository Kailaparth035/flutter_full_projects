import 'package:aspirevue/util/string.dart';
import 'package:get/get.dart';

class Validation {
  bool isNumeric(String str) {
    try {
      int.parse(str);
    } on FormatException {
      return false;
    }
    return true;
  }

  String? emailAndPhoneValidation(String? value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern.toString());
    if (value == null || value.toString().trim().isEmpty) {
      return '${AppString.emptyMessage}phone number or email';
    }
    if (isNumeric(value)) {
      if (value.length != 10) {
        return '${AppString.emptyMessage}valid phone number';
      }
    } else if (!regex.hasMatch(value)) {
      return AppString.pleaseEnterValidEmail;
    }
    return null;
  }

  String? emailValidation(String? value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern.toString());
    if (value == null || value.toString().trim().isEmpty) {
      return AppString.requiredField;
    } else if (!regex.hasMatch(value)) {
      return AppString.pleaseEnterValidEmail;
    }
    return null;
  }

  String? passwordValidation(String? value) {
    if (value == null || value.toString().trim().isEmpty) {
      return '${AppString.emptyMessage}password field';
    } else {
      var passwordLength = value.length;
      if (passwordLength < 6) {
        return AppString.passwordshoudbeatleat;
      }
    }
    return null;
  }

  String? requiredFieldValidation(String? value) {
    if (value == null || value.toString().trim().isEmpty) {
      return AppString.requiredField;
    }
    return null;
  }

  String? phoneNumverValidation(String? value) {
    // Pattern pattern = r'^^[1-9][0-9]{9}$';
    Pattern pattern = r'^^[0-9() -]+$';

    RegExp regex = RegExp(pattern.toString());
    if (value == null || value.toString().trim().isEmpty) {
      return '${AppString.emptyMessage}phone number';
    } else if (!regex.hasMatch(value)) {
      return AppString.phoneNumberinvalied;
    }
    return null;
  }

  String? nameValidation(String? value) {
    if (value == null || value.toString().trim().isEmpty) {
      return '${AppString.emptyMessage}name';
    }
    if (value.length < 3) {
      return AppString.nameLengthMessage;
    }
    return null;
  }

  String? addressValidation(value) {
    if (value == null) {
      return 'key_address_line-1'.tr;
    } else if (value.length < 2) {
      return 'key_address_validation'.tr;
    }
    return null;
  }

  String? address2Validation(value) {
    if (value == null) {
      return 'key_address_line-2'.tr;
    } else if (value.length < 2) {
      return 'key_address_validation'.tr;
    }
    return null;
  }

  String? pincodeValidation(value) {
    if (value == null) {
      return 'Please enter pincode';
    } else if (value.length < 6) {
      return 'Enter valid pincode';
    }
    return null;
  }

  String? dobValidation(String? value) {
    if (value == null || value.toString().trim().isEmpty) {
      return '${AppString.pleaseSelect}Date Of Birth';
    }
    if (value.length < 3) {
      return AppString.nameLengthMessage;
    }
    return null;
  }
}
