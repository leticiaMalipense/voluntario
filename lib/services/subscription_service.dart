import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:queroservoluntario/models/pagination_model.dart';
import 'package:queroservoluntario/models/subscription_job_model.dart';
import 'package:queroservoluntario/models/subscription_model.dart';
import 'package:queroservoluntario/services/preference_service.dart';

import 'config_service.dart';

class SubscriptionService {
  Dio dio = ConfigService.createDio();

  Future<int> create(SubscriptionModel subscriptionModel) async {
    final response = await dio.post(
      ConfigService.URL_API + "/subscription",
      data: jsonEncode(SubscriptionModel.toJson(subscriptionModel)),
    );

    return response.statusCode;
  }

  Future<int> cancel(String id) async {
    final response =
        await dio.patch(ConfigService.URL_API + "/subscription/cancel/" + id);
    return response.statusCode;
  }

  Future<PaginationModel> getByUserId(int page) async {
    String id = PreferenceService().getPreferenceByKey(PreferenceService.USER_ID);
    final response = await dio.get(
        ConfigService.URL_API + "/subscription/user/" + id,
        queryParameters: {
          "page": page.toString(),
          "size": ConfigService.PAGE_SIZE.toString()
        });

    if (response.statusCode == 200) {
      dynamic allSubs = response.data;

      if (allSubs.isEmpty) {
        return null;
      }

      List<dynamic> allItems =  response.data["items"];
      int total =  response.data["total"];

      List<SubscriptionModel> convertedList = allItems.map((element) {
        return SubscriptionModel.toModel(element);
      }).toList();

      return PaginationModel.toModel(total, convertedList);
    } else {
      return null;
    }
  }

  Future<PaginationModel> getByCompanyId(int page) async {
    String id = PreferenceService().getPreferenceByKey(PreferenceService.USER_ID);
    final response = await dio.get(
        ConfigService.URL_API + "/subscription/company/" + id,
        queryParameters: {
          "page": page.toString(),
          "size": ConfigService.PAGE_SIZE.toString()
        });

    if (response.statusCode == 200) {
      dynamic allSubs = response.data;

      if (allSubs.isEmpty) {
        return null;
      }

      List<dynamic> allItems =  response.data["items"];
      int total =  response.data["total"];

      List<SubscriptionJobModel> convertedList = allItems.map((element) {
        return SubscriptionJobModel.toModel(element);
      }).toList();

      return PaginationModel.toModel(total, convertedList);
    } else {
      return null;
    }
  }
}
