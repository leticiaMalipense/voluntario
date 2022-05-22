import 'package:flutter/material.dart';
import 'package:queroservoluntario/components/app_bar.dart';
import 'package:queroservoluntario/enums/job_type.dart';
import 'package:queroservoluntario/models/subscription_job_model.dart';
import 'package:queroservoluntario/utils/app_style.dart';
import 'package:queroservoluntario/utils/validate_fields.dart';
import 'package:queroservoluntario/view/company/view_individual_page.dart';

class ViewSubscriptionPage extends StatefulWidget {
  SubscriptionJobModel subscription;

  ViewSubscriptionPage(SubscriptionJobModel subscription) {
    this.subscription = subscription;
  }

  @override
  _ViewSubscriptionPageState createState() =>
      _ViewSubscriptionPageState(subscription);
}

class _ViewSubscriptionPageState extends State<ViewSubscriptionPage> {
  SubscriptionJobModel subscription;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  JobType _character;
  TextEditingController titleController = TextEditingController();
  TextEditingController dateInitialController = TextEditingController();
  TextEditingController dateFinalController = TextEditingController();

  _ViewSubscriptionPageState(SubscriptionJobModel subscription) {
    this.subscription = subscription;
  }

  @override
  Widget build(BuildContext context) {
    titleController.text = this.subscription.title;
    dateInitialController.text = this.subscription.dateInitial;
    dateFinalController.text = this.subscription.dateFinal;
    _character = JobTypeHelper.getType(this.subscription.type);

    return Scaffold(
        appBar: AppBarComponent.buildAppBar(context),
        backgroundColor: AppColors.backgroudColor,
        body: SingleChildScrollView(
            child: Column(
          children: [
            Form(
                key: _formKey,
                child: Padding(
                    padding: EdgeInsets.only(
                        left: 20.0, top: 10.0, right: 20.0, bottom: 0.0),
                    child: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                          Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          5.0)
                                      )),
                              child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 10.0,
                                            top: 5.0,
                                            right: 10.0,
                                            bottom: 5.0),
                                        child: Text(titleController.text,
                                            style: TextStyle(
                                                color: AppColors.textColor,
                                                fontSize: 28.0))),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 10.0,
                                            top: 5.0,
                                            right: 10.0,
                                            bottom: 5.0),
                                        child: Text(
                                            _character == JobType.RECURRENT
                                                ? 'Vaga recorrente'
                                                : 'Campanha',
                                            style: TextStyle(
                                                color: AppColors.textColor,
                                                fontSize: 17.0))),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 10.0,
                                            top: 5.0,
                                            right: 10.0,
                                            bottom: 5.0),
                                        child: Text(
                                            ValidateFields.formaterDateToShow(
                                                dateInitialController.text),
                                            style: TextStyle(
                                                color: AppColors.textColor,
                                                fontSize: 17.0))),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 10.0,
                                            top: 5.0,
                                            right: 10.0,
                                            bottom: 5.0),
                                        child: Text(
                                            ValidateFields.formaterDateToShow(
                                                dateFinalController.text),
                                            style: TextStyle(
                                                color: AppColors.textColor,
                                                fontSize: 17.0))),
                                  ])),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 10.0,
                                  top: 20.0,
                                  right: 10.0,
                                  bottom: 5.0),
                              child: Text("Lista de candidatos",
                                  style: TextStyle(
                                      color: AppColors.textColor,
                                      fontSize: 17.0))),
                          buildListView()
                        ]))))
          ],
        )));
  }

  ListView buildListView() {
    return ListView.separated(
      padding: EdgeInsets.all(0.0),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 0,
        );
      },
      itemCount: this.subscription.subscriptions.length,
      itemBuilder: (context, index) {
        return Container(
          child: Padding(
            padding:
                EdgeInsets.only(left: 0.0, top: 5.0, right: 0.0, bottom: 5.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey[200],
                child: Icon(Icons.account_circle, color: Colors.grey[800]),
              ),
              title: Text(this.subscription.subscriptions[index].individualName,
                  style: TextStyle(fontSize: 20.0, color: Colors.black)),
              subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(this
                        .subscription
                        .subscriptions[index]
                        .individualOcupation)
                  ]),
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => ViewIndividualPage(this
                            .subscription
                            .subscriptions[index]
                            .individualId)));
              },
            ),
          ),
        );
      },
    );
  }
}
