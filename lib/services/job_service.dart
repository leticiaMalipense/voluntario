import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:queroservoluntario/models/job_model.dart';
import 'package:queroservoluntario/models/pagination_model.dart';
import 'package:queroservoluntario/services/preference_service.dart';

import 'config_service.dart';

class JobService {
  Dio dio = ConfigService.createDio();

  Future<int> createJob(JobModel jobModel) async {
    try {
      String companyId =
          PreferenceService().getPreferenceByKey(PreferenceService.USER_ID);
      jobModel.companyId = companyId;

      final response = await dio.post(
        ConfigService.URL_API + "/job",
        data: jsonEncode(JobModel.toJson(jobModel)),
      );

      if (response.statusCode == 201) {
        return response.statusCode;
      } else {
        return response.statusCode;
      }
    } catch (e) {
      return 0;
    }
  }

  Future<JobModel> getJobById(String id) async {
    try {
      final response = await dio.get(ConfigService.URL_API + "/job/" + id);

      if (response.statusCode == 200) {
        return JobModel.toModel(response.data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<PaginationModel> getAllJobByCompany(int page) async {
    try {
      String companyId = PreferenceService().getPreferenceByKey(PreferenceService.USER_ID);
      final response = await dio.get(ConfigService.URL_API + "/job/company/" + companyId,
          queryParameters: {
          "page": page.toString(),
          "size": ConfigService.PAGE_SIZE.toString()
      });

      if (response.statusCode == 200) {
        dynamic allJobs = response.data;
        if (allJobs.isEmpty) {
          return null;
        }

        List<JobModel> convertedList = [];
        List<dynamic> allItemsJobs =  response.data["items"];
        int total =  response.data["total"];

        for (var i = 0; i < allItemsJobs.length; i++) {
          JobModel job = JobModel.toModel(allItemsJobs[i]);
          convertedList.add(job);
        }
        return PaginationModel.toModel(total, convertedList);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<int> deleteJobById(String id) async {
    try {
      final response = await dio.delete(ConfigService.URL_API + "/job/" + id);
      return response.statusCode;
    } catch (e) {
      return 0;
    }
  }

  Future<int> updateJobById(String id, JobModel jobModel) async {
    try {
      String companyId =
          PreferenceService().getPreferenceByKey(PreferenceService.USER_ID);
      jobModel.companyId = companyId;
      final response = await dio.put(
        ConfigService.URL_API + "/job/" + id,
        data: jsonEncode(JobModel.toJson(jobModel)),
      );

      if (response.statusCode == 201) {
        return response.statusCode;
      } else {
        return response.statusCode;
      }
    } catch (e) {
      return 0;
    }
  }

  Future<PaginationModel> getByFilters(int state, String city, int page) async {
    try {
      String url;

      if(city.isEmpty) {
        url = ConfigService.URL_API + "/job/filter;state=" + state.toString();
      } else {
        url = ConfigService.URL_API + "/job/filter;state=" + state.toString() + ";city=" + city;
      }
      final response = await dio.get(url,
          queryParameters: {
            "page": page.toString(),
            "size": ConfigService.PAGE_SIZE.toString()
          });

      if (response.statusCode == 200) {
        dynamic allJobs = response.data;
        if (allJobs.isEmpty) {
          return null;
        }

        List<dynamic> allItemsJobs =  response.data["items"];
        int total =  response.data["total"];

        List<JobModel> convertedList = allItemsJobs.map((element) {
          return JobModel.toModel(element);
        }).toList();

        return PaginationModel.toModel(total, convertedList);
      } else {
        return null;
      }

    } catch (e) {
      return null;
    }
  }
}
