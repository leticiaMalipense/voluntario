
import 'package:dio/dio.dart';
import 'package:queroservoluntario/models/address_model.dart';
import 'package:queroservoluntario/models/state_model.dart';
import 'package:queroservoluntario/utils/validate_fields.dart';

import 'config_service.dart';

class AddressService {
  Dio dio = ConfigService.createDio();

  Future<List<StateAddress>> getStates() async {
    try {
      final response = await dio.get(ConfigService.URL_API + "/state");

      if (response.statusCode == 200) {
        List<StateAddress> states = [];
        response.data.forEach((element) {
          states.add(StateAddress.toModel(element));
        });
        return states;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<AddressModel> getbyCep(String cep) async {
    try {
      final response = await dio.get(ConfigService.URL_API +
          "/address/cep/" +
          ValidateFields.onlyNumbers(cep));

      if (response.statusCode == 200) {
        return AddressModel.toModel(response.data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
