import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:queroservoluntario/utils/app_style.dart';

class LoadingPagination {
  static Widget loadCirular(bool visible) {
    return Visibility(
        visible: visible,
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 40),
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          ),
        ));
  }
}
