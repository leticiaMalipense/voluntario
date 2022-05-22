import 'package:flutter/material.dart';
import 'package:queroservoluntario/services/navigation_service.dart';
import 'package:queroservoluntario/services/preference_service.dart';
import 'package:queroservoluntario/view/home/home.dart';
import 'package:queroservoluntario/view/initial/initial.dart';
import 'package:queroservoluntario/view/login/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PreferenceService.init();

  runApp(MaterialApp(
    theme: ThemeData(),
    home: Initial(),
    navigatorKey: NavigationService.navigatorKey,
    routes: {"login": (BuildContext context) => Login(), "home": (BuildContext context) => Home(0)}
  ));
}
