import 'package:dio/dio.dart';
import 'package:queroservoluntario/interceptions/authentication_interceptor.dart';
import 'package:queroservoluntario/services/preference_service.dart';

class ConfigService {

  static const String CONTENT_TYPE = 'Content-Type';
  static const String AUTHORIZATION = 'Authorization';
  static const String APPLICATION_JSON = 'application/json; charset=UTF-8';
  static const String URL_API = "http://api.com.br:8080";
  static const PAGE_SIZE = 5;

  static Map<String, String> headers() {
    String token = PreferenceService().getPreferenceByKey(PreferenceService.USER_TOKEN);
    return <String, String>{
      CONTENT_TYPE: APPLICATION_JSON,
      AUTHORIZATION: token
    };
  }

  static Dio createDio() {
    Dio dio = Dio(BaseOptions(
        connectTimeout: 30000,
        receiveTimeout: 30000,
        headers: ConfigService.headers(),
        validateStatus: (status) {
          return true;
        }));

    dio.interceptors.add(AuthenticationInterceptor());
    return dio;
  }
}