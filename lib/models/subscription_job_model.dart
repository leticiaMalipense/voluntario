
import 'package:queroservoluntario/models/subscription_model.dart';

class SubscriptionJobModel {
  String jobId;
  String title;
  String type;
  String dateInitial;
  String dateFinal;
  String quantity;

  List<SubscriptionModel> subscriptions = [];

  static SubscriptionJobModel toModel(Map<String, dynamic> map) {
    SubscriptionJobModel subscriptionJobModel = SubscriptionJobModel();
    subscriptionJobModel.jobId =  map["jobId"].toString();
    subscriptionJobModel.title =  map["title"];
    subscriptionJobModel.type =  map["type"];
    subscriptionJobModel.dateInitial =  map["dateInitial"];
    subscriptionJobModel.dateFinal =  map["dateFinal"];
    subscriptionJobModel.quantity = map["quantity"].toString();

    dynamic list =  map["subscriptions"];
    for (var subs in list) {
      SubscriptionModel subscriptionModel = SubscriptionModel();
      subscriptionModel.id = subs["id"].toString();
      subscriptionModel.individualId = subs["individualId"].toString();
      subscriptionModel.individualName = subs["individualName"];
      subscriptionModel.individualOcupation = subs["individualOcupation"];
      subscriptionModel.companyId = subs["companyId"].toString();
      subscriptionJobModel.subscriptions.add(subscriptionModel);
    }

    return subscriptionJobModel;
  }

}