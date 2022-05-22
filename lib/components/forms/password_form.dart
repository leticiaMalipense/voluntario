import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:queroservoluntario/models/user_model.dart';
import 'package:queroservoluntario/utils/app_style.dart';
import 'package:queroservoluntario/utils/text_string.dart';

import '../input_field.dart';

class PasswordForm {

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmerdController = TextEditingController();

  Widget buildFormIndividual(BuildContext context, Function functionButtonEnter, { UserModel model }) {
    return Center(
      child: Form(
          key: _formKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  child: new Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: new Text(
                      TextString.definitivePasswordMessage,
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                          color: AppColors.textColor, fontSize: 15.0),
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: TextFormField(
                      inputFormatters: [
                        new LengthLimitingTextInputFormatter(6),
                      ],
                      decoration: InputDecoration(
                          filled: true,
                          prefixIcon: Icon(Icons.lock,
                              color: AppColors.backgroudColor),
                          hintStyle: TextStyle(
                              color: AppColors.backgroudColor),
                          fillColor: Colors.black45,
                          hintText: TextString.password),
                      controller: passwordController,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      validator: (value) {
                        return _verifyEqualPassword(value);
                      },
                    )),
                Container(
                  child: new Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: new Text(
                      TextString.confirmPasswordMessage,
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                          color: AppColors.textColor, fontSize: 15.0),
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: TextFormField(
                      inputFormatters: [
                        new LengthLimitingTextInputFormatter(6),
                      ],
                      decoration: InputDecoration(
                          filled: true,
                          prefixIcon: Icon(Icons.lock,
                              color: AppColors.backgroudColor),
                          hintStyle: TextStyle(
                              color: AppColors.backgroudColor),
                          fillColor: Colors.black45,
                          hintText: TextString.password),
                      controller: passwordConfirmerdController,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      validator: (value) {
                        return _verifyEqualPasswordConfirmation(value);
                      },
                    )),
                buildButtonEnter(context, functionButtonEnter),
              ])),
    );

  }

  String _verifyEqualPasswordConfirmation(String value) {
    if (value.isEmpty) {
      return TextString.fieldRequired;
    }
    if (value.length != 6) {
      return TextString.passwordSixCaracterMessage;
    }
    if (passwordController.text != passwordConfirmerdController.text) {
      return TextString.passwordNotIsEqualMessage;
    }
  }

  String _verifyEqualPassword(String value) {
    if (value.isEmpty) {
      return TextString.fieldRequired;
    }
    if (value.length != 6) {
      return TextString.passwordSixCaracterMessage;
    }
  }

  bool validateForm() {
    return _formKey.currentState.validate();
  }

  Padding buildButtonEnter(BuildContext context, Function buttonEnter) {
    return Padding(
      padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
      child: Container(
          height: 50.0,
          child: FieldComponent().buildButtonFormField(
              TextString.nextButton,
              AppColors.titleColor,
              AppColors.primaryColor,
              buttonEnter,
              context)),
    );
  }


}