import 'dart:io';

import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launch/flutter_launch.dart';
import 'package:queroservoluntario/components/app_bar.dart';
import 'package:queroservoluntario/components/image_pick.dart';
import 'package:queroservoluntario/components/loading.dart';
import 'package:queroservoluntario/models/individual_model.dart';
import 'package:queroservoluntario/services/auth_service.dart';
import 'package:queroservoluntario/utils/app_style.dart';
import 'package:queroservoluntario/utils/validate_fields.dart';

class ViewIndividualPage extends StatefulWidget {
  String individualId;

  ViewIndividualPage(String individualId) {
    this.individualId = individualId;
  }

  @override
  _ViewIndividualPageState createState() =>
      _ViewIndividualPageState(this.individualId);
}

class _ViewIndividualPageState extends State<ViewIndividualPage> {
  AuthService _authService = AuthService();
  String individualId;
  bool loading = true;

  IndividualModel individualModel;
  ImagePickComponent imagePickComponent = ImagePickComponent();
  TextEditingController phoneController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _ViewIndividualPageState(String individualId) {
    this.individualId = individualId;
  }

  @override
  void initState() {
    super.initState();

    _authService.getFillUserById(this.individualId).then((response) => {
          this.individualModel = response,
          if(individualModel.imageContent != null) {
            ImagePickComponent.getFile(
                individualModel.imageTitle, individualModel.imageContent)
                .then((value) =>
            {
              individualModel.file = value,
              refreshPage(false),
            })
          } else {
            refreshPage(false),
          }
        });
  }

  void refreshPage(bool value) {
    if (this.mounted) {
      setState(() {
        loading = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarComponent.buildAppBar(context),
        backgroundColor: AppColors.backgroudColor,
        body: loading ? Loading() : buildSingleChildScrollView());
  }

  Form buildSingleChildScrollView() {
    phoneController.text = MagicMask.buildMask(ValidateFields.PHONE_MASK)
        .getMaskedString(
            this.individualModel.phone.ddd + this.individualModel.phone.number);
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              imagePickComponent.buildImagePicker(
                  context, false, refresh, this.individualModel.file),
              Container(
                  margin: EdgeInsets.only(
                      left: 20.0, top: 10.0, right: 20.0, bottom: 10.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(
                                left: 20.0,
                                top: 20.0,
                                right: 10.0,
                                bottom: 0.0),
                            child: Text(this.individualModel.name,
                                style: TextStyle(
                                    color: AppColors.textColor,
                                    fontSize: 22.0))),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 20.0,
                                top: 5.0,
                                right: 10.0,
                                bottom: 17.0),
                            child: Text(
                                "Ocupação: " + this.individualModel.ocupation,
                                style: TextStyle(
                                    color: AppColors.textColor,
                                    fontSize: 17.0)))
                      ])),
              Container(
                  margin: EdgeInsets.only(
                      left: 20.0, top: 10.0, right: 20.0, bottom: 10.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(
                                left: 20.0,
                                top: 20.0,
                                right: 10.0,
                                bottom: 0.0),
                            child: Text(
                                "CEP: " + this.individualModel.address.cep,
                                style: TextStyle(
                                    color: AppColors.textColor,
                                    fontSize: 17.0))),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 20.0, top: 5.0, right: 10.0, bottom: 0.0),
                            child: Text(this.individualModel.address.street,
                                style: TextStyle(
                                    color: AppColors.textColor,
                                    fontSize: 17.0))),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 20.0, top: 5.0, right: 10.0, bottom: 0.0),
                            child: Text(
                                "Numero: " +
                                    this
                                        .individualModel
                                        .address
                                        .number
                                        .toString(),
                                style: TextStyle(
                                    color: AppColors.textColor,
                                    fontSize: 17.0))),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 20.0, top: 5.0, right: 10.0, bottom: 0.0),
                            child: Text(
                                "Cidade: " + this.individualModel.address.city,
                                style: TextStyle(
                                    color: AppColors.textColor,
                                    fontSize: 17.0))),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 20.0,
                                top: 5.0,
                                right: 10.0,
                                bottom: 10.0),
                            child: Text(
                                "Bairro: " +
                                    this.individualModel.address.neighborhood,
                                style: TextStyle(
                                    color: AppColors.textColor,
                                    fontSize: 17.0)))
                      ])),
              Container(
                  margin: EdgeInsets.only(
                      left: 20.0, top: 10.0, right: 20.0, bottom: 10.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(
                                left: 20.0,
                                top: 20.0,
                                right: 10.0,
                                bottom: 0.0),
                            child: Text("Contato",
                                style: TextStyle(
                                    color: AppColors.textColor,
                                    fontSize: 22.0))),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 20.0,
                                top: 0.0,
                                right: 10.0,
                                bottom: 20.0),
                            child: GestureDetector(
                                onTap: () {
                                  openwhatsapp();
                                },
                                child: TextFormField(
                                  enabled: false,
                                  decoration: InputDecoration(
                                      labelText: "",
                                      labelStyle: TextStyle(
                                          color: AppColors.placeholderColor),
                                      suffixIcon: IconButton(
                                        onPressed: openwhatsapp,
                                        icon: Icon(Icons.whatsapp_outlined),
                                      )),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: AppColors.textColor,
                                      fontSize: 20.0),
                                  controller: phoneController,
                                )))
                      ])),
            ],
          ),
        ));
  }

  openwhatsapp() async {
    await FlutterLaunch.launchWhatsapp(
        phone: "55" + ValidateFields.onlyNumbers(phoneController.text),
        message: "Olá");
  }

  refresh(File image) {
    setState(() {
      imagePickComponent.image = image;
    });
  }
}
