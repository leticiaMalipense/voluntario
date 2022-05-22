import 'package:flutter/material.dart';
import 'package:queroservoluntario/components/app_bar.dart';
import 'package:queroservoluntario/components/dialog_message.dart';
import 'package:queroservoluntario/components/forms/password_form.dart';
import 'package:queroservoluntario/components/loading.dart';
import 'package:queroservoluntario/enums/user_type.dart';
import 'package:queroservoluntario/models/user_model.dart';
import 'package:queroservoluntario/services/auth_service.dart';
import 'package:queroservoluntario/utils/app_style.dart';
import 'package:queroservoluntario/utils/text_string.dart';
import 'package:queroservoluntario/view/home/home.dart';

class PasswordPage extends StatefulWidget {
  UserModel user;

  PasswordPage(this.user);

  @override
  _PasswordPageState createState() => _PasswordPageState(this.user);
}

class _PasswordPageState extends State<PasswordPage> {
  final AuthService _authService = AuthService();
  UserModel user;

  _PasswordPageState(this.user);

  PasswordForm _passwordForm = PasswordForm();
  bool loading = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarComponent.buildAppBar(context),
        backgroundColor: AppColors.backgroudColor,
        body:  loading ? Loading() : SingleChildScrollView(
            padding: EdgeInsets.all(20.0),
            child: _passwordForm.buildFormIndividual(context, _buttonEnter)
        ));
  }

  Future<void> _buttonEnter(BuildContext context) async {
    if (_passwordForm.validateForm()) {
      refreshPage(true);
      this.user.password = _passwordForm.passwordController.text;

      _authService.registerUser(this.user).then((statusCode) => {
        if (statusCode == 201) {
          refreshPage(false),
          if(this.user.type == UserTypeHelper.getValue(UserType.INDIVIDUAL)) {
              Navigator.of(context).pushAndRemoveUntil(
              new MaterialPageRoute<Null>(
                  builder: (BuildContext context) => Home(0)),
                  (Route<dynamic> route) => false)
          } else {
            refreshPage(false),
            setState(() {
              DialogMessage()
                  .showSuccessMessage(context, "Por favor aguarda análise do seu cadastro", false, reset: true);
            })
          }
        } else if(statusCode == 409) {
          refreshPage(false),
          setState(() {
            DialogMessage()
                .showErroMessage(context, TextString.userConflict, false);
          })
        }
        else {
          refreshPage(false),
          setState(() {
            DialogMessage()
                .showErroMessage(context, TextString.messageErro, false);
          })
       }
      });
    }
  }

  void refreshPage(bool value) {
    if (this.mounted) {
      setState(() {
        loading = value;
      });
    }
  }
}
