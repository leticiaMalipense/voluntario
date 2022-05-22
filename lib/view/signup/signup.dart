import 'package:flutter/material.dart';
import 'package:queroservoluntario/components/app_bar.dart';
import 'package:queroservoluntario/components/forms/company_form.dart';
import 'package:queroservoluntario/components/forms/individual_form.dart';
import 'package:queroservoluntario/enums/user_type.dart';
import 'package:queroservoluntario/models/user_model.dart';
import 'package:queroservoluntario/utils/app_style.dart';
import 'package:queroservoluntario/view/signup/address_page.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  CompanyForm _companyForm = CompanyForm();
  IndividualForm _individualForm = IndividualForm();

  UserType _character = UserType.INDIVIDUAL;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBarComponent.buildAppBar(context),
        backgroundColor: AppColors.backgroudColor,
        body: buildFormOne());
  }

  Container buildFormOne() {
    return Container(
      child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
          child: Column(children: [
            Row(children: <Widget>[
              Flexible(
                  fit: FlexFit.loose,
                  child: RadioListTile<UserType>(
                    title: Text('Voluntário'),
                    value: UserType.INDIVIDUAL,
                    groupValue: _character,
                    onChanged: (UserType value) {
                      setState(() {
                        _character = value;
                      });
                    },
              )),
              Flexible(
                fit: FlexFit.loose,
                child: RadioListTile<UserType>(
                  title: Text('Instituição'),
                  value: UserType.COMPANY,
                  groupValue: _character,
                  onChanged: (UserType value) {
                    setState(() {
                      _character = value;
                    });
                  },
                ),
              ),
            ]),
            buildFormIndividual(_character == UserType.INDIVIDUAL),
            buildFormCompany(_character == UserType.COMPANY),
          ])),
    );
  }

  Widget buildFormIndividual(bool show) {
    return Visibility(
        visible: show,
        child: _individualForm.buildFormIndividual(context, true, true, buttonEnter),
    );
  }

  Widget buildFormCompany(bool show) {
    return Visibility(
      visible: show,
      child: _companyForm.buildFormCompany(context, true, true, buttonEnter),
    );
  }

  Function buttonEnter(BuildContext context) {
    if (_character == UserType.INDIVIDUAL) {
      if (_individualForm.validateForm()) {
        nextPage(context, _individualForm.getIndividual());
        _individualForm.resetFields();
      }
    } else {
      if (_companyForm.validateForm()) {
        nextPage(context, _companyForm.getCompany());
        _companyForm.resetFields();
      }
    }
  }

  void nextPage(BuildContext context, UserModel userModel) {
      changePage(context, userModel);
  }

  void changePage(BuildContext context, UserModel user) {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return Address(user);
        },
        fullscreenDialog: true));
  }
}
