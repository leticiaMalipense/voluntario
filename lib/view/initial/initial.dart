import 'package:flutter/material.dart';
import 'package:queroservoluntario/services/preference_service.dart';
import 'package:queroservoluntario/utils/app_style.dart';
import 'package:queroservoluntario/utils/text_string.dart';
import 'package:queroservoluntario/view/home/home.dart';
import 'package:queroservoluntario/view/login/login.dart';
import 'package:queroservoluntario/view/signup/signup.dart';

import 'information.dart';

class Initial extends StatefulWidget {
  @override
  _InitialState createState() => _InitialState();
}

class _InitialState extends State<Initial> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroudColor,
        body: Stack(
          children: [
            Container(
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                      fit: BoxFit.cover,
                      image: ExactAssetImage('images/initial.png'))),
            ),
            Stack(
              children: [
                Positioned(
                  top: 100.0,
                  height: 50.0,
                  child: Container(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      TextString.appName,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                          fontSize: 30.0),
                    ),
                  ),
                ),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SingleChildScrollView(
                        padding: EdgeInsets.only(bottom: 100.0),
                        child: Container(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                TextString.beChange,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryColor,
                                    fontSize: 20.0),
                              ),
                              buildButtonLogin(),
                              buildButtonSignup(),
                              buildInformationButton()
                            ],
                          ),
                        ),
                      ),
                    ]),
              ],
            ),
          ],
        ));
  }

  Padding buildButtonSignup() {
    return Padding(
      padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
      child: Container(
        height: 50.0,
        child: TextButton(
            onPressed: () {
              _signupDialog();
            },
            child: Text(
              TextString.enter,
              style: TextStyle(color: AppColors.primaryColor, fontSize: 15.0),
            ),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white.withOpacity(0.6)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(color: AppColors.primaryColor, width: 3.0))))),
      ),
    );
  }

  Padding buildButtonLogin() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0, bottom: 2.0),
      child: Container(
        height: 50.0,
        child: TextButton(
            onPressed: () {
              _loginDialog();
            },
            child: Text(
              TextString.login,
              style: TextStyle(color: AppColors.titleColor, fontSize: 15.0),
            ),
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: BorderSide(color: AppColors.primaryColor, width: 3.0))),
              backgroundColor:
                  MaterialStateProperty.all(AppColors.primaryColor),
            )),
      ),
    );
  }

  Padding buildInformationButton() {
    return Padding(
      padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
      child: Container(
        height: 50.0,
        child: TextButton(
            onPressed: () {
              _information();
            },
            child: Text(
              "QUEM SOMOS",
              style: TextStyle(color: AppColors.textContrast, fontSize: 15.0),
            ),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white.withOpacity(0.6)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(color: AppColors.textContrast, width: 3.0))
                )
            )
        ),
      ),
    );
  }

  void _loginDialog() {
    String id = PreferenceService().getPreferenceByKey(PreferenceService.USER_ID);
    String token = PreferenceService().getPreferenceByKey(PreferenceService.USER_TOKEN);

    if(id.isEmpty || token.isEmpty) {
      Navigator.of(context).push(new MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return Login();
          },
          fullscreenDialog: true));
    } else {
      Navigator.of(context).push(new MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return Home(0);
          },
          fullscreenDialog: true));
    }
  }

  void _signupDialog() {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return Signup();
        },
        fullscreenDialog: true));
  }

  void _information() {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return Information();
        },
        fullscreenDialog: true));
  }
}
