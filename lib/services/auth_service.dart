import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:queroservoluntario/enums/user_type.dart';
import 'package:queroservoluntario/models/token_model.dart';
import 'package:queroservoluntario/models/user_model.dart';
import 'package:queroservoluntario/services/preference_service.dart';

import 'config_service.dart';

class AuthService {
  Dio dio = ConfigService.createDio();

  Future<int> signInUser(String email, String password) async {
    try {
      final response = await dio.post(ConfigService.URL_API + "/auth", data: jsonEncode({'user': email, 'pass': password}));

      if (response.statusCode == 200) {
        TokenModel token = TokenModel.toModel(response.data);
        PreferenceService().savePreference(token);
        return response.statusCode;
      } else {
        return response.statusCode;
      }
    } catch (e) {
      return 0;
    }
  }

  Future<int> registerUser(UserModel userModel) async {
    try {
      final response = await dio.post(
        ConfigService.URL_API + "/user",
        data: jsonEncode(UserModel.toJson(userModel)),
      );

      if (response.statusCode == 201) {
        if(userModel.type == UserTypeHelper.getValue(UserType.INDIVIDUAL)) {
          PreferenceService().savePreference(TokenModel.toModel(response.data));
        }
        return response.statusCode;
      } else {
        return response.statusCode;
      }
    } catch (e) {
      return 0;
    }
  }

  Future<UserModel> getUser() async {
    try {
      String id =
      PreferenceService().getPreferenceByKey(PreferenceService.USER_ID);
      final response = await dio.get(ConfigService.URL_API + "/user/" + id);

      if (response.statusCode == 200) {
        return UserModel.toModel(response.data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<UserModel> getUserById(String id) async {
    try {
      final response = await dio.get(ConfigService.URL_API + "/user/" + id);

      if (response.statusCode == 200) {
        return UserModel.toModel(response.data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<UserModel> getFillUser() async {
    try {
      String id =
          PreferenceService().getPreferenceByKey(PreferenceService.USER_ID);
      final response =
          await dio.get(ConfigService.URL_API + "/user/" + id + "/fill");

      if (response.statusCode == 200) {
        return UserModel.toModel(response.data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<UserModel> getFillUserById(String id) async {
    try {
      final response =
          await dio.get(ConfigService.URL_API + "/user/" + id + "/fill");

      if (response.statusCode == 200) {
        return UserModel.toModel(response.data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<int> updateUser(UserModel userModel) async {
    try {
      String id =
          PreferenceService().getPreferenceByKey(PreferenceService.USER_ID);

      final response = await dio.put(
        ConfigService.URL_API + "/user/" + id,
        data: jsonEncode(UserModel.toJson(userModel)),
      );

      if (response.statusCode == 204) {
        return response.statusCode;
      } else {
        return response.statusCode;
      }
    } catch (e) {
      return 0;
    }
  }

  Future<void> logout() async {
    try {
      PreferenceService().removeAllPreference();
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<int> recoveryPasswordUser(String email) async {
    try {
      final response = await dio.post(ConfigService.URL_API + "/user/recovery",
          data: jsonEncode({"email": email}));

      return response.statusCode;
    } catch (e) {
      return 0;
    }
  }

  String getUserId() {
    return PreferenceService().getPreferenceByKey(PreferenceService.USER_ID);
  }

  updatePassword(String newPassword) async {
    try {
      String id =
          PreferenceService().getPreferenceByKey(PreferenceService.USER_ID);

      String passwordConverted = base64.encode(utf8.encode(newPassword));

      final response = await dio.patch(
          ConfigService.URL_API + "/user/change-password/" + id,
          data: jsonEncode({"newPassword": passwordConverted}));

      return response.statusCode;
    } catch (e) {
      return 0;
    }
  }
}
