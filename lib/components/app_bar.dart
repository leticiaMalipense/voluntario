import 'package:flutter/material.dart';
import 'package:queroservoluntario/utils/app_style.dart';
import 'package:queroservoluntario/utils/text_string.dart';

class AppBarComponent {

  static PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(TextString.appName),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      backgroundColor: AppColors.primaryColor,
    );
  }

}