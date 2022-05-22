import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:queroservoluntario/components/app_bar.dart';
import 'package:queroservoluntario/components/dialog_message.dart';
import 'package:queroservoluntario/components/forms/password_form.dart';
import 'package:queroservoluntario/services/auth_service.dart';
import 'package:queroservoluntario/utils/app_style.dart';
import 'package:queroservoluntario/utils/text_string.dart';
import 'package:queroservoluntario/view/home/home.dart';

class ChangePasswordPage extends StatefulWidget {

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {

  final AuthService _authService = AuthService();
  PasswordForm _passwordForm = PasswordForm();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarComponent.buildAppBar(context),
        backgroundColor: AppColors.backgroudColor,
        body: Container(
          child: SingleChildScrollView(
              padding: EdgeInsets.all(20.0),
              child: _passwordForm.buildFormIndividual(context, _buttonEnter)
          ),
    ));
  }

  Future<void> _buttonEnter(BuildContext context) async {
    if (_passwordForm.validateForm()) {
      String newPassword = _passwordForm.passwordController.text;

      _authService.updatePassword(newPassword).then((statusCode) => {
        if (statusCode == 200) {
          Navigator.of(context).pushAndRemoveUntil(
              new MaterialPageRoute<Null>(
                  builder: (BuildContext context) => Home(0)),
                  (Route<dynamic> route) => false)
        }
        else {
            setState(() {
              DialogMessage()
                  .showErroMessage(context, TextString.messageErro, false);
            })
          }
      });
    }
  }
}
