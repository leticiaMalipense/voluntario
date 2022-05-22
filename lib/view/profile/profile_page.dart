import 'dart:io';

import 'package:flutter/material.dart';
import 'package:queroservoluntario/components/app_bar_home.dart';
import 'package:queroservoluntario/components/dialog_message.dart';
import 'package:queroservoluntario/components/forms/address_form.dart';
import 'package:queroservoluntario/components/forms/company_form.dart';
import 'package:queroservoluntario/components/forms/individual_form.dart';
import 'package:queroservoluntario/components/image_pick.dart';
import 'package:queroservoluntario/components/input_field.dart';
import 'package:queroservoluntario/components/loading.dart';
import 'package:queroservoluntario/enums/user_type.dart';
import 'package:queroservoluntario/models/image_model.dart';
import 'package:queroservoluntario/models/state_model.dart';
import 'package:queroservoluntario/models/user_model.dart';
import 'package:queroservoluntario/services/address_service.dart';
import 'package:queroservoluntario/services/auth_service.dart';
import 'package:queroservoluntario/utils/app_style.dart';
import 'package:queroservoluntario/utils/text_string.dart';
import 'package:queroservoluntario/utils/validate_fields.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage();

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  AddressService addressService = AddressService();
  List<StateAddress> list = [];

  UserModel _userModel;

  bool loading = true;
  String messageErro = "";
  String cepChange = "";

  IndividualForm _individualForm = IndividualForm();
  CompanyForm _companyForm = CompanyForm();
  AddressForm _addressForm = AddressForm();
  ImagePickComponent imagePickComponent = ImagePickComponent();

  @override
  Future<void> initState() {
    _authService
        .getFillUser()
        .then((response) => {
          _userModel = response,
          if(_userModel.imageContent != null) {
            ImagePickComponent.getFile(
                _userModel.imageTitle, _userModel.imageContent)
                .then((value) =>
            {
              _userModel.file = value,
              refreshPage(false),
            })
          } else {
            refreshPage(false),
          }
    });

    if (_addressForm.dropdownStateList.length <= 1) {
      _addressForm.dropdownStateList.add(_addressForm.stateSelected);
      addressService.getStates().then((value) => {
            if (this.mounted)
              {
                setState(() {
                  this.list = value;
                  _addressForm.dropdownStateList.addAll(value);
                })
              }
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarHomeComponent.buildAppBar(context),
        backgroundColor: AppColors.backgroudColor,
        body: loading
            ? Loading()
            : SingleChildScrollView(child: buildContainer(context)));
  }

  Widget buildContainer(BuildContext context) {
    if (_userModel != null) {
      return buildPage(context);
    } else {
      setState(() {
        loading = true;
      });
    }
  }

  Column buildPage(BuildContext context) {
    if (_userModel.type ==
        UserTypeHelper.getValue(UserType.INDIVIDUAL).toString()) {
      return Column(
        children: [
          imagePickComponent.buildImagePicker(
              context, true, refresh, this._userModel.file),
          _individualForm.buildFormIndividual(
              context, false, false, buttonEnter,
              model: _userModel),
          _addressForm.buildForm(
              context, false, buttonEnter, refreshComboState, seachCep,
              model: _userModel.address),
          buildButtonEnter()
        ],
      );
    } else {
      return Column(children: [
        imagePickComponent.buildImagePicker(
            context, true, refresh, this._userModel.file),
        _companyForm.buildFormCompany(context, false, false, buttonEnter,
            model: _userModel),
        _addressForm.buildForm(
            context, false, buttonEnter, refreshComboState, seachCep,
            model: _userModel.address),
        buildButtonEnter()
      ]);
    }
  }

  refresh(File image) {
    setState(() {
      imagePickComponent.image = image;
    });
  }

  Padding buildButtonEnter() {
    return Padding(
        padding:
            EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0, bottom: 10.0),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Container(
              height: 50.0,
              child: FieldComponent().buildButtonFormField(
                  "Salvar",
                  AppColors.titleColor,
                  AppColors.primaryColor,
                  buttonEnter,
                  context))
        ]));
  }

  seachCep(String value) {
    if (ValidateFields.onlyNumbers(value).length >= 8) {
      if (cepChange.compareTo(value) != 0) {
        addressService
            .getbyCep(ValidateFields.onlyNumbers(value))
            .then((addressModel) => {
                  if (addressModel != null)
                    {
                      _addressForm.fillFieldsCep(addressModel),
                      _addressForm.dropdownStateList.forEach((element) {
                        if (element.id == addressModel.stateId) {
                          setState(() {
                            _addressForm.enableFields = false;
                            _addressForm.stateSelected = element;
                            _addressForm.dropdownStateList = [element];
                          });
                        }
                      })
                    }
                  else
                    {
                      _addressForm.cleanFieldsCep(),
                      resetCombo(),
                      setState(() {
                        _addressForm.enableFields = true;
                      })
                    }
                });
      }
    } else if (_addressForm.dropdownStateList == null ||
        _addressForm.dropdownStateList.length <= 1) {
      setState(() {
        _addressForm.enableFields = true;
        _addressForm.dropdownStateList = this.list;
      });
      resetCombo();
    } else if (!_addressForm.enableFields &&
        ValidateFields.onlyNumbers(value).length < 8) {
      setState(() {
        _addressForm.enableFields = true;
      });
    }
  }

  void resetCombo() {
    return _addressForm.dropdownStateList.forEach((element) {
      if (element.id == null) {
        setState(() {
          _addressForm.stateSelected = element;
        });
      }
    });
  }

  Function refreshComboState(StateAddress newValue) {
    setState(() {
      _addressForm.stateSelected = newValue;
    });
  }

  void refreshPage(bool value) {
    if (this.mounted) {
      setState(() {
        loading = value;
      });
    }
  }

  buttonEnter(BuildContext context) async {
    refreshPage(true);
    if (_userModel.type ==
        UserTypeHelper.getValue(UserType.INDIVIDUAL).toString()) {
      if (_individualForm.validateForm() && _addressForm.validateForm()) {
        this._userModel = _individualForm.getIndividual();
        this._userModel.address = _addressForm.getAddress();

        ImageModel imageModel = await imagePickComponent.generateImage();

        if (imageModel != null) {
          this._userModel.imageTitle = imageModel.title;
          this._userModel.imageContent = imageModel.image;
        }
        updateUser();

      }
    } else {
      if (_companyForm.validateForm() && _addressForm.validateForm()) {
        this._userModel = _companyForm.getCompany();
        this._userModel.address = _addressForm.getAddress();

        ImageModel imageModel = await imagePickComponent.generateImage();

        if (imageModel != null) {
          this._userModel.imageTitle = imageModel.title;
          this._userModel.imageContent = imageModel.image;
        }

        updateUser();
      }
    }
  }

  void updateUser() {
    _authService.updateUser(_userModel).then((statusCode) => {
          refreshPage(false),
          if (statusCode == 204)
            {
              if(this.mounted) {
                messageSuccess(context)
              }
            }
          else
            {
              setState(() {
                DialogMessage()
                    .showErroMessage(context, TextString.messageErro, false);
              })
            }
        });
  }

  void messageSuccess(BuildContext context) {
    setState(() {
      DialogMessage()
          .showErroMessage(context, TextString.userUpdateSuccess, false);
    });
  }
}
