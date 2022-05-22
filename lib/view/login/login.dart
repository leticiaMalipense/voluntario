import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:queroservoluntario/components/app_bar.dart';
import 'package:queroservoluntario/components/dialog_message.dart';
import 'package:queroservoluntario/components/input_field.dart';
import 'package:queroservoluntario/components/loading.dart';
import 'package:queroservoluntario/components/loading_pagination.dart';
import 'package:queroservoluntario/services/auth_service.dart';
import 'package:queroservoluntario/utils/app_style.dart';
import 'package:queroservoluntario/utils/text_string.dart';
import 'package:queroservoluntario/view/home/home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _authService = AuthService();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordRecoveryController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> _formRecoveryKey = GlobalKey<FormState>();

  bool _isLoadMoreRunning = false;

  void resetFields() async {
    emailController.text = '';
    passwordController.text = '';
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroudColor,
        appBar: AppBarComponent.buildAppBar(context),
        body: loading ? Loading() : buildForm(context));
  }

  void refreshPage(bool value) {
    if (this.mounted) {
      setState(() {
        loading = value;
      });
    }
  }

  void refreshLoad(bool value) {
    if (this.mounted) {
      setState(() {
        _isLoadMoreRunning = value;
        FocusScope.of(context).requestFocus(new FocusNode());
      });
    }
  }

  Form buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: (TextFormField(
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                              hintStyle: TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: Colors.black45,
                              hintText: TextString.email),
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value.isEmpty) {
                              return TextString.fieldRequired;
                            }
                            if (!EmailValidator.validate(value)) {
                              return TextString.emailInvalid;
                            }
                          }))),
                  Container(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: TextFormField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(6),
                        ],
                        decoration: InputDecoration(
                            filled: true,
                            prefixIcon: Icon(Icons.lock,
                                color: AppColors.backgroudColor),
                            hintStyle:
                                TextStyle(color: AppColors.backgroudColor),
                            fillColor: Colors.black45,
                            hintText: TextString.password),
                        controller: passwordController,
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        validator: (value) {
                          if (value.isEmpty) {
                            return TextString.fieldRequired;
                          }
                        },
                      )),
                  Container(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: TextButton(
                          onPressed: () {
                            modalPassword(context);
                          },
                          child: Text(
                            TextString.forgotPassword,
                            style: TextStyle(color: AppColors.primaryColor),
                          ))),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: FieldComponent().buildButtonFormField(
                              TextString.login,
                              AppColors.titleColor,
                              AppColors.primaryColor,
                              autenticaUser,
                              context),
                        )
                      ]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void modalPassword(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Form(
                      key: _formRecoveryKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text(
                                  TextString.passwordRecoveryMessage,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: 15.0),
                                ),
                              ),
                            ),
                            Container(
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: FieldComponent().buildTextFormField(
                                    "email",
                                    true,
                                    true,
                                    passwordRecoveryController,
                                    TextInputType.emailAddress,
                                    valdidateEmail,
                                    null),
                              ),
                            ),
                            LoadingPagination.loadCirular(
                                this._isLoadMoreRunning),
                            Container(
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: TextButton(
                                    onPressed: () => recoveryPassword(context),
                                    child: Text(
                                      TextString.send,
                                      style: TextStyle(
                                          color: AppColors.titleColor,
                                          fontSize: 15.0,
                                          height: 2),
                                    ),
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              side: BorderSide(
                                                  color:
                                                      AppColors.primaryColor))),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              AppColors.primaryColor),
                                    )),
                              ),
                            ),
                          ]))));
        }).whenComplete(() {
      passwordRecoveryController.text = '';
    });
  }

  valdidateEmail(String value) {
    if (value.isEmpty) {
      return TextString.fieldRequired;
    }
    if (!EmailValidator.validate(value)) {
      return TextString.emailInvalid;
    }
  }

  recoveryPassword(BuildContext context) async {
    if (!_isLoadMoreRunning) {
      refreshLoad(true);

      if (_formRecoveryKey.currentState.validate()) {
        int response = await _authService
            .recoveryPasswordUser(passwordRecoveryController.text);
        if (response == 200) {
          setState(() {
            _isLoadMoreRunning = false;
            FocusScope.of(context).requestFocus(new FocusNode());
            DialogMessage().showSuccessMessage(
                context, TextString.recoveryEmailSuccess, true);
          });
        } else {
          refreshLoad(false);
          DialogMessage()
              .showErroMessage(context, TextString.recoveryEmailError, true);
        }
      }
    } else {
      return null;
    }

  }

  void autenticaUser(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      refreshPage(true);
      final password = utf8.encode(passwordController.text);
      _authService
          .signInUser(emailController.text, base64.encode(password))
          .then((statusCode) => {
                if (statusCode == 200)
                  {
                    refreshPage(false),
                    Navigator.of(context).push(new MaterialPageRoute<Null>(
                        builder: (BuildContext context) {
                          return Home(0);
                        },
                        fullscreenDialog: true))
                  }
                else if (statusCode == 0)
                  {
                    refreshPage(false),
                    setState(() {
                      DialogMessage().showErroMessage(
                          context, TextString.messageErro, false);
                    })
                  }
                else
                  {
                    refreshPage(false),
                    setState(() {
                      DialogMessage().showErroMessage(
                          context, TextString.userNotFound, false);
                    })
                  }
              });
    }
  }
}
