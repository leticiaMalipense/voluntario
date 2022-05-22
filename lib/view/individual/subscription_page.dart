import 'dart:io';

import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:queroservoluntario/components/app_bar.dart';
import 'package:queroservoluntario/components/dialog_message.dart';
import 'package:queroservoluntario/components/image_pick.dart';
import 'package:queroservoluntario/components/input_field.dart';
import 'package:queroservoluntario/components/loading.dart';
import 'package:queroservoluntario/enums/job_type.dart';
import 'package:queroservoluntario/models/job_model.dart';
import 'package:queroservoluntario/models/subscription_model.dart';
import 'package:queroservoluntario/services/auth_service.dart';
import 'package:queroservoluntario/services/job_service.dart';
import 'package:queroservoluntario/services/subscription_service.dart';
import 'package:queroservoluntario/utils/app_style.dart';
import 'package:queroservoluntario/utils/text_string.dart';
import 'package:queroservoluntario/utils/validate_fields.dart';
import 'package:flutter_launch/flutter_launch.dart';
import 'package:queroservoluntario/view/home/home.dart';

class SubscriptionPage extends StatefulWidget {
  JobModel jobModel;
  String jobId;

  SubscriptionPage(JobModel jobModel) {
    this.jobModel = jobModel;
  }

  @override
  _SubscriptionPageState createState() => _SubscriptionPageState(this.jobModel);
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  SubscriptionService _subscriptionService = SubscriptionService();
  JobService _jobService = JobService();
  AuthService _authService = AuthService();
  JobModel jobModel;

  bool loading = true;

  _SubscriptionPageState(JobModel jobModel) {
    this.jobModel = jobModel;
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ImagePickComponent imagePickComponent = ImagePickComponent();

  TextEditingController nameCompanyController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dateInitialController = TextEditingController();
  TextEditingController dateFinalController = TextEditingController();
  JobType _character;

  @override
  void initState() {
    if (this.jobModel.load) {
      String subscriptionId = this.jobModel.subscriptionId;
      _jobService.getJobById(this.jobModel.id).then((value) => {
            this.jobModel = value,
            this.jobModel.load = true,
            this.jobModel.subscriptionId = subscriptionId,
            setState(() {
              loading = false;
            })
          });
    } else {
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
        body: loading ? Loading() : buildContainer(context));
  }

  Container buildContainer(BuildContext context) {
    _character = JobTypeHelper.getType(this.jobModel.type);
    nameCompanyController.text = this.jobModel.companyName;
    phoneController.text = MagicMask.buildMask(ValidateFields.PHONE_MASK)
        .getMaskedString(this.jobModel.phoneDdd + this.jobModel.phoneNumber);
    ;
    titleController.text = this.jobModel.title;
    descriptionController.text = this.jobModel.description;
    emailController.text = this.jobModel.email;

    dateInitialController.text =
        ValidateFields.formaterDateToShow(this.jobModel.dateInitial);
    dateFinalController.text =
        ValidateFields.formaterDateToShow(this.jobModel.dateFinal);

    return Container(
      child: SingleChildScrollView(
          child: Column(
        children: [
          Form(
              key: _formKey,
              child: Padding(
                  padding: EdgeInsets.only(
                      left: 20.0, top: 50.0, right: 20.0, bottom: 20.0),
                  child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                        RadioListTile<JobType>(
                          contentPadding: EdgeInsets.all(0.0),
                          title: Text(
                              _character == JobType.SINGLE
                                  ? 'Campanha'
                                  : 'Vaga recorrente',
                              style: TextStyle(
                                  color: AppColors.textColor, fontSize: 20.0)),
                        ),
                        FieldComponent().buildTextFormField(
                            "Instituição",
                            true,
                            false,
                            nameCompanyController,
                            TextInputType.name,
                            null,
                            null),
                        FieldComponent().buildTextFormField(
                            "Email",
                            true,
                            false,
                            emailController,
                            TextInputType.name,
                            null,
                            null),
                        GestureDetector(
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
                                color: AppColors.textColor, fontSize: 20.0),
                            controller: phoneController,
                          ),
                        ),
                        FieldComponent().buildTextFormField(
                            "Título",
                            true,
                            false,
                            titleController,
                            TextInputType.name,
                            null,
                            null),
                        TextFormField(
                          keyboardType: TextInputType.multiline,
                          enabled: false,
                          minLines: 1,
                          maxLines: 5,
                          maxLength: 150,
                          controller: descriptionController,
                          validator: (val) {
                            if (val.isEmpty) {
                              return TextString.fieldRequired;
                            }
                          },
                          decoration: InputDecoration(
                              labelText: "Descrição da vaga",
                              labelStyle:
                                  TextStyle(color: AppColors.placeholderColor)),
                          style: TextStyle(
                              color: AppColors.textColor, fontSize: 20.0),
                        ),
                        buildDateSingle(_character == JobType.SINGLE),
                        buildDateRecurrent(_character == JobType.RECURRENT),
                        buildSubscription()
                      ]))))
        ],
      )),
    );
  }

  Widget buildDateSingle(bool show) {
    return Visibility(
        visible: show,
        child: TextFormField(
            enabled: false,
            controller: dateInitialController,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.dialpad, color: AppColors.primaryColor),
                labelStyle: TextStyle(color: AppColors.placeholderColor)),
            textAlign: TextAlign.left,
            style: TextStyle(color: AppColors.textColor, fontSize: 20.0)));
  }

  Widget buildDateRecurrent(bool show) {
    return Visibility(
      visible: show,
      child: Column(children: [
        TextFormField(
            enabled: false,
            controller: dateInitialController,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.dialpad, color: AppColors.primaryColor),
                labelStyle: TextStyle(color: AppColors.placeholderColor)),
            textAlign: TextAlign.left,
            style: TextStyle(color: AppColors.textColor, fontSize: 20.0)),
        TextFormField(
            enabled: false,
            controller: dateFinalController,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.dialpad, color: AppColors.primaryColor),
                labelStyle: TextStyle(color: AppColors.placeholderColor)),
            textAlign: TextAlign.left,
            style: TextStyle(color: AppColors.textColor, fontSize: 20.0))
      ]),
    );
  }

  refresh(File image) {
    setState(() {
      imagePickComponent.image = image;
    });
  }

  Padding buildSubscription() {
    return Padding(
        padding:
            EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0, bottom: 10.0),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Container(
              height: 50.0,
              child: FieldComponent().buildButtonFormField(
                  this.jobModel.load ? "Remover inscrição" : "Inscrever-se",
                  AppColors.titleColor,
                  AppColors.primaryColor,
                  this.jobModel.load
                      ? buttonSubscriptionCancel
                      : buttonSubscriptionCreate,
                  context))
        ]));
  }

  Function buttonSubscriptionCreate(BuildContext context) {
    refreshPage(true);
    SubscriptionModel subs = SubscriptionModel();
    subs.jobId = this.jobModel.id;
    subs.companyId = this.jobModel.companyId;
    subs.individualId = _authService.getUserId();

    _subscriptionService.create(subs).then((statusCode) => {
          if (statusCode == 201)
            {
              refreshPage(false),
              Navigator.of(context).pushAndRemoveUntil(
                  new MaterialPageRoute<Null>(
                      builder: (BuildContext context) => Home(0)),
                  (Route<dynamic> route) => false)
            }
          else if (statusCode == 409)
            {
              refreshPage(false),
              setState(() {
                DialogMessage().showErroMessage(
                    context, TextString.subcriptionConflict, false);
              })
            }
          else
            {
              refreshPage(false),
              setState(() {
                DialogMessage()
                    .showErroMessage(context, TextString.messageErro, false);
              })
            }
        });
  }

  Function buttonSubscriptionCancel(BuildContext context) {
    refreshPage(true);
    _subscriptionService
        .cancel(this.jobModel.subscriptionId)
        .then((statusCode) => {
              if (statusCode == 204)
                {
                  refreshPage(false),
                  Navigator.of(context).pushAndRemoveUntil(
                      new MaterialPageRoute<Null>(
                          builder: (BuildContext context) => Home(1)),
                      (Route<dynamic> route) => false)
                }
              else
                {
                  refreshPage(false),
                  setState(() {
                    DialogMessage().showErroMessage(
                        context, TextString.messageErro, false);
                  })
                }
            });
  }

  openwhatsapp() async {
    await FlutterLaunch.launchWhatsapp(
        phone: "55" + ValidateFields.onlyNumbers(phoneController.text),
        message: "Olá");
  }

  void refreshPage(bool value) {
    if (this.mounted) {
      setState(() {
        loading = value;
      });
    }
  }
}
