import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:queroservoluntario/enums/user_type.dart';
import 'package:queroservoluntario/models/individual_model.dart';
import 'package:queroservoluntario/utils/app_style.dart';
import 'package:queroservoluntario/utils/text_string.dart';
import 'package:queroservoluntario/utils/validate_fields.dart';

import '../input_field.dart';

class IndividualForm {

  GlobalKey<FormState> _formIndividualKey = GlobalKey<FormState>();

  TextEditingController nameIndividualController = TextEditingController();
  TextEditingController emailIndividualController = TextEditingController();
  TextEditingController ocupationController = TextEditingController();
  TextEditingController cpfController = TextEditingController();
  TextEditingController cellphoneController = TextEditingController();

  void resetFields() {
      nameIndividualController.text = '';
      emailIndividualController.text = '';
      cpfController.text = '';
      ocupationController.text = '';
      cellphoneController.text = '';
  }

  bool isFillFields() {
    return nameIndividualController.text.isEmpty
        && emailIndividualController.text.isEmpty
        && cpfController.text.isEmpty
        && ocupationController.text.isEmpty
        && cellphoneController.text.isEmpty;
  }

  Widget buildFormIndividual(BuildContext context, bool enable, bool showButton, Function buttonEnter, { IndividualModel model }) {
    if(model != null && isFillFields()) {
      nameIndividualController.text = model.name;
      emailIndividualController.text = model.email;
      cpfController.text = MagicMask.buildMask(ValidateFields.CPF_MASK).getMaskedString(model.document);
      ocupationController.text = model.ocupation;
      cellphoneController.text = MagicMask.buildMask(ValidateFields.PHONE_MASK).getMaskedString(model.phone.ddd + model.phone.number);
    }

    return Container(
        child: Padding(
          padding: EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
          child: Form(
            key: this._formIndividualKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                    enabled: enable,
                    decoration: InputDecoration(
                        labelText:  "Email",
                        labelStyle: TextStyle(color: AppColors.placeholderColor )),
                    textAlign: TextAlign.left,
                    style: TextStyle(color: enable ? AppColors.textColor : Colors.grey, fontSize: 20.0),
                    controller: emailIndividualController,
                   ),
                FieldComponent().buildTextFormField(
                    "Nome completo",
                    true,
                    true,
                    nameIndividualController,
                    TextInputType.name,
                    null,
                    null),
                FieldComponent().buildTextFormField(
                    "CPF",
                    true,
                    true,
                    cpfController,
                    TextInputType.number,
                    ValidateFields.valdidateSizeCpf,
                    TextInputMask(
                        mask: ValidateFields.CPF_MASK)),
                FieldComponent().buildTextFormField(
                    "Celular",
                    true,
                    true,
                    cellphoneController,
                    TextInputType.number,
                    ValidateFields.valdidateSizeCellphone,
                    TextInputMask(
                        mask: ValidateFields.PHONE_MASK)),
                FieldComponent().buildTextFormField(
                    "Ocupação",
                    true,
                    true,
                    ocupationController,
                    TextInputType.text,
                    null,
                    null),
                    buildButtonEnter(context, showButton, buttonEnter),
              ],
            ),
          ),
        ));
  }

  Visibility buildButtonEnter(BuildContext context, bool showButton, Function action) {
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
                action,
                context)),
      )
    );
  }

  bool validateForm() {
    return _formIndividualKey.currentState.validate();
  }

  IndividualModel getIndividual() {
    IndividualModel individualModel = IndividualModel();
    individualModel.email = emailIndividualController.text;
    individualModel.name = nameIndividualController.text;
    individualModel.document = cpfController.text;
    individualModel.type = UserTypeHelper.getValue(UserType.INDIVIDUAL);
    individualModel.ocupation = ocupationController.text;

    individualModel.phone =  ValidateFields.getCellphone(cellphoneController.text);

    return individualModel;
  }

}