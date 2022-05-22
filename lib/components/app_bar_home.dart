import 'package:flutter/material.dart';
import 'package:queroservoluntario/services/auth_service.dart';
import 'package:queroservoluntario/utils/app_style.dart';
import 'package:queroservoluntario/utils/text_string.dart';
import 'package:queroservoluntario/view/initial/initial.dart';
import 'package:queroservoluntario/view/profile/change_password_page.dart';

class AppBarHomeComponent {
  static PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(TextString.appName),
      automaticallyImplyLeading: false,
      actions: [
        PopupMenuButton<String>(
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<String>(child: Text('Alterar senha'), value: 'change'),
              PopupMenuItem<String>(child: Text('Sair'), value: 'logout'),
            ];
          },
          onSelected: (value) {
            switch (value) {
              case 'change':
                Navigator.push(context,
                    new MaterialPageRoute(
                        builder: (context) => ChangePasswordPage()));
                break;
              case 'logout':
                AuthService().logout().then((value) => {
                  Navigator.push(context,
                      new MaterialPageRoute(
                          builder: (context) => Initial()))
                });
                break;
            }
          },
        ),
      ],
      centerTitle: true,
      backgroundColor: AppColors.primaryColor,
    );
  }
}
