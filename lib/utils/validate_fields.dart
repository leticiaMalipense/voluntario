
import 'package:email_validator/email_validator.dart';
import 'package:intl/intl.dart';
import 'package:queroservoluntario/models/phone_model.dart';
import 'package:queroservoluntario/utils/text_string.dart';

class ValidateFields {
  static const String CEP_MASK = "99.999-999";
  static const String PHONE_MASK = "(99) 99999-9999";
  static const String CNPJ_MASK = "99.999.999/9999-99";
  static const String CPF_MASK = "999.999.999-99";
  static const String DATE_FORMAT_TO_SHOW = "dd/MM/yyyy HH:mm:ss";
  static const String DATE_FORMAT_TO_SEND = "yyyy-MM-dd'T'HH:mm:ss";

  static String valdidateEmail(String value) {
    if (value.isEmpty) {
      return TextString.fieldRequired;
    }
    if (!EmailValidator.validate(value)) {
      return TextString.emailInvalid;
    }
  }

  static String valdidateSizeCpf(String value) {
    if (value.length != 14) {
      return TextString.fieldRequired;
    }
  }

  static String valdidateSizeCnpj(String value) {
    if (value.length != 18) {
      return TextString.fieldRequired;
    }
  }

  static String valdidateSizeCellphone(String value) {
    if (value.trim().length != 15) {
      return TextString.fieldRequired;
    }
  }

  static String valdidateCep(String value) {
    if (onlyNumbers(value).length != 8) {
      return TextString.fieldRequired;
    }
  }

  static String onlyNumbers(String value) {
    return value.replaceAll(new RegExp(r'[^0-9]'),'');
  }

  static PhoneModel getCellphone(String phone) {
    PhoneModel phoneModel = PhoneModel();
    var onlyNumbersCellphone = onlyNumbers(phone).trim();
    phoneModel.ddd = onlyNumbersCellphone.substring(0,2);
    phoneModel.number = onlyNumbersCellphone.substring(2, onlyNumbersCellphone.length);

    return phoneModel;
  }

  static String maskCellPhone(){
    return "";
  }

  static DateTime formaterDateToDate(String date) {
    if(date.isEmpty) {
      return DateTime.now();
    }
    DateTime dateTime = DateFormat(ValidateFields.DATE_FORMAT_TO_SHOW).parse(date);
    return dateTime;
  }

  static String formaterDateToSend(String date) {
    if(date.isEmpty) {
      return "";
    }
    DateTime dateTime = DateFormat(ValidateFields.DATE_FORMAT_TO_SHOW).parse(date);
    return DateFormat(ValidateFields.DATE_FORMAT_TO_SEND).format(dateTime);
  }

  static String formaterDateToShow(String date) {
    if(date != null && date.isNotEmpty) {
      DateTime dateTime = DateFormat(ValidateFields.DATE_FORMAT_TO_SEND).parse(date);
      return DateFormat(ValidateFields.DATE_FORMAT_TO_SHOW).format(dateTime);
    }
    return "";
  }

  static String formaterDate(DateTime date) {
    if(date != null ) {
      return DateFormat(ValidateFields.DATE_FORMAT_TO_SHOW).format(date);
    }
    return "";
  }

}