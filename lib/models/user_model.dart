import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:queroservoluntario/components/image_pick.dart';
import 'package:queroservoluntario/enums/user_type.dart';
import 'package:queroservoluntario/models/address_model.dart';
import 'package:queroservoluntario/models/company_model.dart';
import 'package:queroservoluntario/models/individual_model.dart';
import 'package:queroservoluntario/models/phone_model.dart';
import 'package:queroservoluntario/utils/validate_fields.dart';

class UserModel {
  String id;
  String name;
  String email;
  String document;
  String password;
  String type;
  String complement;
  AddressModel address;
  PhoneModel phone;

  String imageTitle;
  Uint8List imageContent;
  File file;

  static UserModel toModel(Map<String, dynamic> map) {
    UserModel userModel;

    if(UserType.INDIVIDUAL == UserTypeHelper.getType(map["type"])) {
      IndividualModel individualModel = IndividualModel();
      individualModel.id = map["id"].toString();
      individualModel.name = map["name"];
      individualModel.email = map["email"];
      individualModel.document = map["document"];
      individualModel.type = map["type"];
      individualModel.ocupation = map["ocupation"];
      userModel = individualModel;
    } else {
      CompanyModel companyModel = CompanyModel();
      companyModel.id = map["id"].toString();
      companyModel.name = map["name"];
      companyModel.email = map["email"];
      companyModel.document = map["document"];
      companyModel.occupationArea = map["occupationArea"];
      companyModel.description =  map["description"];
      companyModel.type = map["type"];
      userModel = companyModel;
    }

    AddressModel addressModel = AddressModel();
    addressModel.stateId = map["address"]["idState"];
    addressModel.stateName = map["address"]["nameState"];
    addressModel.city = map["address"]["city"];
    addressModel.number = map["address"]["number"];
    addressModel.neighborhood = map["address"]["neighborhood"];
    addressModel.street = map["address"]["street"];
    addressModel.cep = map["address"]["cep"];
    addressModel.complement = map["address"]["complement"];
    userModel.address =  addressModel;

    PhoneModel phone = PhoneModel();
    phone.ddd = map["phones"][0]["ddd"].toString();
    phone.number = map["phones"][0]["number"].toString();
    userModel.phone = phone;

    if(map["image"] != null) {
      userModel.imageTitle = map["image"]["title"];
      userModel.imageContent = base64.decode(map["image"]["image"]);
    }

    return userModel;
  }

  static Map<String, dynamic> toJson(UserModel userModel) {
    Map<String, dynamic> mapUser;

    Map<String, String> mapAddress = {
      "idState": userModel.address.stateId.toString(),
      "city": userModel.address.city,
      "number": userModel.address.number.toString(),
      "neighborhood": userModel.address.neighborhood,
      "street": userModel.address.street,
      "complement": userModel.address.complement,
      "cep": ValidateFields.onlyNumbers(userModel.address.cep)
    };

    Map<String, String> mapPhone = {
      "ddd": userModel.phone.ddd,
      "number": userModel.phone.number
    };

    if(UserType.INDIVIDUAL == UserTypeHelper.getType(userModel.type)) {
      IndividualModel individualModel = userModel;
      mapUser = {
        "name": individualModel.name,
        "email": individualModel.email,
        "document": ValidateFields.onlyNumbers(individualModel.document),
        "type": individualModel.type,
        "ocupation": individualModel.ocupation,
        "address": mapAddress,
        "phones": [mapPhone]
      };

      if(individualModel.password != null) {
        mapUser.putIfAbsent("password", () => base64.encode(utf8.encode(individualModel.password)));
      }

      if(userModel.imageTitle != null && userModel.imageContent != null) {
        var mapImageJob = {
          "title": userModel.imageTitle,
          "image": base64.encode(userModel.imageContent)
        };

        mapUser.putIfAbsent("image", () => mapImageJob);

      }

    } else {
      CompanyModel companyModel = userModel;
      mapUser = {
        "name": companyModel.name,
        "email": companyModel.email,
        "document": ValidateFields.onlyNumbers(companyModel.document),
        "occupationArea": companyModel.occupationArea,
        "description": companyModel.description,
        "type": companyModel.type,
        "address": mapAddress,
        "phones": [mapPhone]
      };

      if(companyModel.password != null) {
        mapUser.putIfAbsent("password", () => base64.encode(utf8.encode(companyModel.password)));
      }

      if(userModel.imageTitle != null && userModel.imageContent != null) {
        var mapImageJob = {
          "title": userModel.imageTitle,
          "image": base64.encode(userModel.imageContent)
        };

        mapUser.putIfAbsent("image", () => mapImageJob);

      }
    }

    return mapUser;
  }
}
