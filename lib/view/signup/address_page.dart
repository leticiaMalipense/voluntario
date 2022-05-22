import 'package:flutter/material.dart';
import 'package:queroservoluntario/components/app_bar.dart';
import 'package:queroservoluntario/components/forms/address_form.dart';
import 'package:queroservoluntario/components/loading.dart';
import 'package:queroservoluntario/models/state_model.dart';
import 'package:queroservoluntario/models/user_model.dart';
import 'package:queroservoluntario/services/address_service.dart';
import 'package:queroservoluntario/utils/app_style.dart';
import 'package:queroservoluntario/utils/validate_fields.dart';
import 'package:queroservoluntario/view/signup/password_page.dart';

class Address extends StatefulWidget {
  bool loading = true;
  UserModel user;

  Address(this.user);

  @override
  _AddressState createState() => _AddressState(this.user);
}

class _AddressState extends State<Address> {
  bool loading = true;
  AddressService addressService = AddressService();
  List<StateAddress> list = [];
  String cepChange = "";

  UserModel user;

  _AddressState(this.user);

  AddressForm _addressForm = AddressForm();

  @override
  Future<void> initState() {
    super.initState();

    if (_addressForm.dropdownStateList.length <= 1) {
      _addressForm.dropdownStateList.add(_addressForm.stateSelected);
      addressService.getStates().then((value) => setState(() {
            this.list = value;
            _addressForm.dropdownStateList.addAll(value);
            refreshPage();
          }));
    }
  }

  void refreshPage() {
    if(this.mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarComponent.buildAppBar(context),
        backgroundColor: AppColors.backgroudColor,
        body: Container(child: loading ? Loading() : buildFormTwo()));
  }

  Form buildFormTwo() {
    return _addressForm.buildForm(
        context, true, buttonEnter, refreshComboState, seachCep);
  }

  seachCep(String value) {
    if (ValidateFields.onlyNumbers(value).length >= 8) {
      //_btnController.success();
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

  Function buttonEnter(BuildContext context) {
    if (_addressForm.validateForm()) {
      this.user.address = _addressForm.getAddress();

      Navigator.of(context).push(new MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return PasswordPage(this.user);
          },
          fullscreenDialog: true));
      _addressForm.resetFields();
    }
  }
}
