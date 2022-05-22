
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:queroservoluntario/components/image_pick.dart';

class JobModel {
  String id;
  String companyId;
  String email;
  String companyName;
  String phoneDdd;
  String phoneNumber;
  String type;
  String title;
  String description;
  String dateInitial;
  String dateFinal;
  String imageTitle;
  Uint8List imageContent;
  bool load = false;
  String subscriptionId;

  static JobModel toModel(Map<String, dynamic> map) {
    JobModel jobModel = JobModel();
    jobModel.id = map["id"].toString();
    jobModel.companyId = map["companyId"].toString();
    jobModel.companyName = map["companyName"].toString();
    jobModel.phoneDdd =  map["phone"]["ddd"].toString();
    jobModel.phoneNumber =  map["phone"]["number"].toString();
    jobModel.type = map["type"];
    jobModel.title = map["title"];
    jobModel.description = map["description"];
    jobModel.dateInitial = map["dateInitial"];
    jobModel.dateFinal = map["dateFinal"];
    jobModel.email = map["email"];

    if(map["image"] != null) {
      jobModel.imageTitle = map["image"]["title"];
      jobModel.imageContent = base64.decode(map["image"]["image"]);
    }

    return jobModel;
  }

  static Map<String, dynamic> toJson(JobModel jobModel) {
    Map<String, dynamic> mapJob = {
      "companyId": jobModel.companyId,
      "type": jobModel.type,
      "title": jobModel.title,
      "description": jobModel.description,
      "dateInitial": jobModel.dateInitial
    };

    if(jobModel.dateFinal.isNotEmpty) {
      mapJob.addAll({
        "dateFinal": jobModel.dateFinal
      });
    }

    if(jobModel.imageTitle != null && jobModel.imageContent != null) {
      var mapImageJob = {
        "title": jobModel.imageTitle,
        "image": base64.encode(jobModel.imageContent)
      };
      mapJob.putIfAbsent("image", () => mapImageJob);
    }
    return mapJob;
  }
}
