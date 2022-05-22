import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:queroservoluntario/enums/user_type.dart';
import 'package:queroservoluntario/models/company_model.dart';
import 'package:queroservoluntario/utils/app_style.dart';
import 'package:queroservoluntario/utils/text_string.dart';
import 'package:queroservoluntario/utils/validate_fields.dart';

import '../input_field.dart';

class CompanyForm {

  GlobalKey<FormState> _formCompanyKey = GlobalKey<FormState>();

  TextEditingController nameCompanyController = TextEditingController();
  TextEditingController emailCompanyController = TextEditingController();
  TextEditingController cellphoneController = TextEditingController();
  TextEditingController cnpjController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  void resetFields() {
    nameCompanyController.text = '';
    emailCompanyController.text = '';
    cnpjController.text = '';
    descriptionController.text = '';
    areaController.text = '';
    cellphoneController.text = '';
  }

  bool isFillFields() {
    return nameCompanyController.text.isEmpty
           && emailCompanyController.text.isEmpty
           && cnpjController.text.isEmpty
           && descriptionController.text.isEmpty
           && areaController.text.isEmpty
           && cellphoneController.text.isEmpty;
  }

  Widget buildFormCompany(BuildContext context, bool showButton, bool enable, Function buttonEnter,{ CompanyModel model }) {
    if(model != null && isFillFields()) {
      nameCompanyController.text = model.name;
      emailCompanyController.text = model.email;
      cnpjController.text = MagicMask.buildMask(ValidateFields.CNPJ_MASK).getMaskedString(model.document);
      descriptionController.text = model.description;
      areaController.text = model.occupationArea;
      cellphoneController.text = MagicMask.buildMask(ValidateFields.PHONE_MASK).getMaskedString(model.phone.ddd + model.phone.number);
    }

    return Container(
        child: Form(
          key: _formCompanyKey,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
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
                  controller: emailCompanyController,
                ),
                FieldComponent().buildTextFormField(
                    "Nome",
                    true,
                    true,
                    nameCompanyController,
                    TextInputType.name,
                    null,
                    null),
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
                    "CNPJ",
                    true,
                    true,
                    cnpjController,
                    TextInputType.number,
                    ValidateFields.valdidateSizeCnpj,
                    TextInputMask(
                        mask: ValidateFields.CNPJ_MASK)),
                FieldComponent().buildTextFormField(
                    "Área de atuação",
                    true,
                    true,
                    areaController,
                    TextInputType.text,
                    null,
                    null),
                FieldComponent().buildTextFormField(
                    "Breve descrição",
                    true,
                    true,
                    descriptionController,
                    TextInputType.text,
                    null,
                    null),
                buildButtonEnter(context, showButton, buttonEnter),
              ],
            ),
          ),
        ));
  }

  bool validateForm() {
    return _formCompanyKey.currentState.validate();
  }

  CompanyModel getCompany() {
    CompanyModel company = CompanyModel();
    company.email = emailCompanyController.text;
    company.type = UserTypeHelper.getValue(UserType.COMPANY);
    company.name = nameCompanyController.text;
    company.document = cnpjController.text;
    company.occupationArea = areaController.text;
    company.description = descriptionController.text;

    company.phone = ValidateFields.getCellphone(cellphoneController.text);

    return company;
  }

  Visibility buildButtonEnter(BuildContext context, bool showButton, Function buttonEnter) {
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

}