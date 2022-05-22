import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:queroservoluntario/models/address_model.dart';
import 'package:queroservoluntario/models/state_model.dart';
import 'package:queroservoluntario/services/address_service.dart';
import 'package:queroservoluntario/utils/app_style.dart';
import 'package:queroservoluntario/utils/text_string.dart';
import 'package:queroservoluntario/utils/validate_fields.dart';

import '../input_field.dart';

abstract class AddressFormInterface {
  void refreshScreen() {}
}

class AddressForm {
  AddressService addressService = AddressService();

  TextEditingController zipCodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController neighborhoodController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController complementoController = TextEditingController();

  static const String selectString = "Selecione";
  StateAddress stateSelected = StateAddress(null, selectString, "");

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<StateAddress> dropdownStateList = [];

  bool enableFields = false;
  Form form;

  bool isFillFields() {
    return zipCodeController.text.isEmpty &&
        cityController.text.isEmpty &&
        streetController.text.isEmpty &&
        neighborhoodController.text.isEmpty &&
        numberController.text.isEmpty;
  }

  Form buildForm(
      BuildContext context,
      bool showButton,
      Function buildButtonEnter,
      Function refreshComboState,
      Function refreshZipCode,
      {AddressModel model}) {
    if (model != null && isFillFields()) {
      zipCodeController.text = MagicMask.buildMask(ValidateFields.CEP_MASK)
          .getMaskedString(model.cep);
      cityController.text = model.city;
      streetController.text = model.street;
      neighborhoodController.text = model.neighborhood;
      numberController.text = model.number.toString();
      complementoController.text = model.complement;

      dropdownStateList.forEach((element) {
        if (element.id == model.stateId) {
          stateSelected = element;
        }
      });
    }

    form = Form(
        key: _formKey,
        child: Padding(
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                  Visibility(
                      visible: showButton,
                      child: Text('Informe seu endereço',
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                              color: AppColors.primaryColor, fontSize: 20.0))),
                  TextFormField(
                      inputFormatters: [
                        TextInputMask(mask: ValidateFields.CEP_MASK)
                      ],
                      keyboardType: TextInputType.number,
                      enabled: true,
                      onChanged: (newValue) {
                        refreshZipCode(newValue);
                      },
                      decoration: InputDecoration(
                          labelText: "CEP",
                          labelStyle:
                              TextStyle(color: AppColors.placeholderColor)),
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(color: AppColors.textColor, fontSize: 20.0),
                      controller: zipCodeController,
                      validator: (val) {
                        if (val.isEmpty) {
                          return TextString.fieldRequired;
                        }
                        ValidateFields.valdidateCep(val);
                      }),
                  buildComboState(context, refreshComboState),
                  FieldComponent().buildTextFormField(
                      "Cidade",
                      true,
                      true,
                      cityController,
                      TextInputType.name,
                      null,
                      null),
                  FieldComponent().buildTextFormField(
                      "Endereço",
                      true,
                      true,
                      streetController,
                      TextInputType.name,
                      null,
                      null),
                  FieldComponent().buildTextFormField(
                      "Bairro",
                      true,
                      true,
                      neighborhoodController,
                      TextInputType.text,
                      null,
                      null),
                  FieldComponent().buildTextFormField("Número", true, true,
                      numberController, TextInputType.number, null, TextInputMask(mask: "999999999")),
                  FieldComponent().buildTextFormField(
                      "Complemento (opcional)",
                      false,
                      true,
                      complementoController,
                      TextInputType.text,
                      null,
                      null),
                  buttonEnter(context, showButton, buildButtonEnter),
                ]))));

    return form;
  }

  Widget buildComboState(BuildContext context, refreshComboState) {
    return DropdownButtonFormField<StateAddress>(
      itemHeight: 100.0,
      isExpanded: true,
      value: stateSelected,
      iconSize: 40.0,
      elevation: 16,
      style: TextStyle(color: AppColors.textColor, fontSize: 20.0),
      onChanged: (StateAddress newValue) {
        refreshComboState(newValue);
      },
      validator: (value) {
        return _validateRequiredDropdown(stateSelected.name);
      },
      items: dropdownStateList
          .map<DropdownMenuItem<StateAddress>>((StateAddress value) {
        return DropdownMenuItem<StateAddress>(
          value: value,
          child: Text(value.name),
        );
      }).toList(),
    );
  }

  String _validateRequiredDropdown(String field) {
    if (field == selectString) {
      return TextString.fieldRequired;
    }
  }

  AddressModel getAddress() {
    AddressModel addressModel = AddressModel();
    addressModel.cep = zipCodeController.text;
    addressModel.stateId = stateSelected.id;
    addressModel.city = cityController.text;
    addressModel.street = streetController.text;
    addressModel.neighborhood = neighborhoodController.text;
    addressModel.complement = complementoController.text;
    addressModel.number =
        numberController.text.isEmpty ? null : int.parse(numberController.text);

    return addressModel;
  }

  void cleanFieldsCep() {
    cityController.text = "";
    streetController.text = "";
    neighborhoodController.text = "";
  }

  void fillFieldsCep(AddressModel addressModel) {
    cityController.text = addressModel.city;
    streetController.text = addressModel.street;
    neighborhoodController.text = addressModel.neighborhood;
  }

  void resetFields() {
    zipCodeController.text = "";
    cityController.text = "";
    streetController.text = "";
    neighborhoodController.text = "";
    numberController.text = "";
    enableFields = false;
  }

  Visibility buttonEnter(
      BuildContext context, bool showButton, Function buttonEnter) {
    return Visibility(
      visible: showButton,
      child: Padding(
        padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
        child: Container(
            height: 50.0,
            child: FieldComponent().buildButtonFormField(
                TextString.nextButton,
                AppColors.titleColor,
                AppColors.primaryColor,
                buttonEnter,
                context)),
      ),
    );
  }

  bool validateForm() {
    return _formKey.currentState.validate();
  }
}
