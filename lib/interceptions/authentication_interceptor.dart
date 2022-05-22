import 'package:dio/dio.dart';
import 'package:queroservoluntario/services/auth_service.dart';
import 'package:queroservoluntario/services/navigation_service.dart';

class AuthenticationInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if(response.statusCode == 403) {
      AuthService().logout().then((value) => {
        NavigationService().navigateTo("login").then((value) => {
          handler.next(response),
          print(response)
        }),
      });
    } else {
      handler.next(response);
    }
  }

}