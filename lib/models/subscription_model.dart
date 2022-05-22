
class SubscriptionModel {
  String id;
  String individualId;
  String individualName;
  String individualOcupation;
  String companyId;
  String jobId;
  String title;
  String dateInitial;
  String dateFinal;

  static SubscriptionModel toModel(Map<String, dynamic> map) {
    SubscriptionModel subscriptionModel = SubscriptionModel();
    subscriptionModel.id = map["id"].toString();
    subscriptionModel.individualId = map["individualId"].toString();
    subscriptionModel.companyId = map["companyId"].toString();
    subscriptionModel.jobId =  map["jobId"].toString();
    subscriptionModel.title =  map["title"];
    subscriptionModel.dateInitial =  map["dateInitial"];
    subscriptionModel.dateFinal =  map["dateFinal"];

    return subscriptionModel;
  }

  static Map<String, dynamic> toJson(SubscriptionModel jobModel) {
    Map<String, dynamic> map = {
      "companyId": jobModel.companyId,
      "individualId": jobModel.individualId,
      "jobId": jobModel.jobId
    };
    return map;
  }

}