import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:queroservoluntario/utils/app_style.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SpinKitFadingCircle(
        color: AppColors.primaryColor,
        size: 50.0,
      ),
    );
  }
}
