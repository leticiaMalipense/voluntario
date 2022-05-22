import 'package:flutter/material.dart';
import 'package:queroservoluntario/components/app_bar.dart';
import 'package:queroservoluntario/components/input_field.dart';
import 'package:queroservoluntario/utils/app_style.dart';
import 'package:queroservoluntario/utils/text_string.dart';

class PhotoPage extends StatefulWidget {
  @override
  _PhotoPage createState() => _PhotoPage();
}

class _PhotoPage extends State<PhotoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarComponent.buildAppBar(context),
        backgroundColor: AppColors.backgroudColor,
        body: Column());
  }
}
