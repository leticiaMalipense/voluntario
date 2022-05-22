import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:queroservoluntario/components/app_bar.dart';
import 'package:queroservoluntario/components/character_summary.dart';
import 'package:queroservoluntario/components/dialog_message.dart';
import 'package:queroservoluntario/components/image_pick.dart';
import 'package:queroservoluntario/components/input_field.dart';
import 'package:queroservoluntario/components/loading.dart';
import 'package:queroservoluntario/enums/job_type.dart';
import 'package:queroservoluntario/models/image_model.dart';
import 'package:queroservoluntario/models/job_model.dart';
import 'package:queroservoluntario/services/job_service.dart';
import 'package:queroservoluntario/utils/app_style.dart';
import 'package:queroservoluntario/utils/text_string.dart';
import 'package:queroservoluntario/utils/validate_fields.dart';
import 'package:queroservoluntario/view/home/home.dart';

class SignupJobPage extends StatefulWidget {
  JobModel jobModel = JobModel();

  SignupJobPage(JobModel jobModel) {
    this.jobModel = jobModel;
  }

  @override
  _SignupJobPageState createState() => _SignupJobPageState(this.jobModel);
}

class _SignupJobPageState extends State<SignupJobPage> {
  final PagingController<int, CharacterSummary> _pagingController = PagingController(firstPageKey: 0);

  JobModel jobModel = JobModel();
  final JobService _jobService = JobService();

  ImagePickComponent imagePickComponent = ImagePickComponent();

  _SignupJobPageState(JobModel jobModel) {
    this.jobModel = jobModel;
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateInitialController = TextEditingController();
  TextEditingController dateFinalController = TextEditingController();

  JobType _character = JobType.RECURRENT;
  DateTime selectedDate = DateTime.now();

  File image;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    if (isUpdate()) {
      _character = JobTypeHelper.getType(this.jobModel.type);
      titleController.text = this.jobModel.title;
      descriptionController.text = this.jobModel.description;
      dateInitialController.text =
          ValidateFields.formaterDateToShow(this.jobModel.dateInitial);
      dateFinalController.text =
          ValidateFields.formaterDateToShow(this.jobModel.dateFinal);
    }

    return Scaffold(
        appBar: AppBarComponent.buildAppBar(context),
        backgroundColor: AppColors.backgroudColor,
        body: Container(
            child: loading ? Loading() : buildSingleChildScrollView(context)));
  }

  SingleChildScrollView buildSingleChildScrollView(BuildContext context) {
    return SingleChildScrollView(
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
                          title: Text('Vaga recorrente',
                              style: TextStyle(
                                  color: AppColors.textColor, fontSize: 20.0)),
                          value: JobType.RECURRENT,
                          groupValue: _character,
                          onChanged: (JobType value) {
                            setState(() {
                              _character = value;
                              if (isUpdate()) {
                                this.jobModel.type =
                                    JobTypeHelper.getValue(_character);
                              }
                            });
                          },
                        ),
                        RadioListTile<JobType>(
                          contentPadding: EdgeInsets.all(0.0),
                          title: Text('Campanha',
                              style: TextStyle(
                                  color: AppColors.textColor, fontSize: 20.0)),
                          value: JobType.SINGLE,
                          groupValue: _character,
                          onChanged: (JobType value) {
                            setState(() {
                              _character = value;
                              if (isUpdate()) {
                                this.jobModel.type =
                                    JobTypeHelper.getValue(_character);
                              }
                            });
                          },
                        ),
                        FieldComponent().buildTextFormField(
                            "Título",
                            true,
                            true,
                            titleController,
                            TextInputType.name,
                            null,
                            null),
                        TextFormField(
                          keyboardType: TextInputType.multiline,
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
                        buildData(),
                        buildButtonEnter()
                      ]))))
        ],
      ),
    );
  }

  bool isUpdate() => this.jobModel != null && this.jobModel.id != null;

  Widget buildData() {
    return Visibility(
      visible: true,
      child: Column(children: [
        FieldComponent().buildDatePicker(_selectDateSingle, true, this.context,
            dateInitialController, "Date initial"),
        FieldComponent().buildDatePicker(_selectDateSingle, true, this.context,
            dateFinalController, "Date final"),
      ]),
    );
  }

  Future<void> _selectDateSingle(
      BuildContext context, TextEditingController controller) async {
      DateTime dateCurrent;

      if(controller.text != null){
        dateCurrent = ValidateFields.formaterDateToDate(controller.text);
      } else {
        dateCurrent = DateTime.now();
      }

      final DateTime picked = await DatePicker.showDateTimePicker(context,
          showTitleActions: true,
          minTime: DateTime(DateTime.now().year, 0, 0),
          maxTime: DateTime(2050, 0, 0), onChanged: (date) {
            print('change $date');
          }, onConfirm: (date) {
            print('confirm $date');
          }, currentTime: dateCurrent, locale: LocaleType.en);

      if (picked != null && picked != selectedDate)
        setState(() {
          selectedDate = picked;
          controller.text =
              DateFormat(ValidateFields.DATE_FORMAT_TO_SHOW).format(selectedDate);

          if (isUpdate()) {
            if (controller == dateInitialController) {
              this.jobModel.dateInitial = setInitialDate();
            } else {
              this.jobModel.dateFinal = setFinalDate();
            }
          }
        });
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

  void refreshPage(bool value) {
    if (this.mounted) {
      setState(() {
        loading = value;
      });
    }
  }

  Future<void> buttonEnter(BuildContext context) async {
    refreshPage(true);
    if (_formKey.currentState.validate()) {
      JobModel job = JobModel();
      job.title = titleController.text;
      job.description = descriptionController.text;
      job.type = JobTypeHelper.getValue(_character);
      job.dateInitial = setInitialDate();
      job.dateFinal = setFinalDate();

      ImageModel imageModel = await imagePickComponent.generateImage();

      if (imageModel != null) {
        job.imageTitle = imageModel.title;
        job.imageContent = imageModel.image;
      }

      if (isUpdate()) {
        updateUser(this.jobModel.id, job, context);
      } else {
        createUser(job, context);
      }
    } else {
      refreshPage(false);
    }
  }

  String setFinalDate() =>
      ValidateFields.formaterDateToSend(dateFinalController.text);

  String setInitialDate() =>
      ValidateFields.formaterDateToSend(dateInitialController.text);

  void createUser(JobModel job, BuildContext context) {
    _jobService.createJob(job).then((statusCode) => {
          if (statusCode == 201)
            {
              refreshPage(false),
              Navigator.of(context).pushAndRemoveUntil(
                  new MaterialPageRoute<Null>(
                      builder: (BuildContext context) => Home(0)),
                  (Route<dynamic> route) => false)
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

  void updateUser(String id, JobModel job, BuildContext context) {
    _jobService.updateJobById(id, job).then((statusCode) => {
          if (statusCode == 204)
            {
              refreshPage(false),
              Navigator.of(context).pushAndRemoveUntil(
                  new MaterialPageRoute<Null>(
                      builder: (BuildContext context) => Home(0)),
                  (Route<dynamic> route) => false)
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
}
