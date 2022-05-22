import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:queroservoluntario/utils/app_style.dart';
import 'package:queroservoluntario/utils/text_string.dart';

class FieldComponent {
  TextButton buildButtonFormField(String label, Color titleColor, Color color,
      Function pressed, BuildContext context) {
    return TextButton(
        onPressed: () => pressed(context),
        child: Text(
          label,
          style: TextStyle(color: titleColor, fontSize: 15.0, height: 2),
        ),
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  side: BorderSide(color: color))),
          backgroundColor: MaterialStateProperty.all(color),
        ));
  }

  TextFormField buildTextFormField(String label, bool required, bool enable,
      TextEditingController controller, TextInputType keyBoard,
      Function(String) validatorFun, TextInputMask mask) {
    return TextFormField(
        inputFormatters: mask != null ? [mask] : null,
        keyboardType: keyBoard,
        enabled: enable,
        decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: AppColors.placeholderColor )),
        textAlign: TextAlign.left,
        style: TextStyle(color: AppColors.textColor, fontSize: 20.0),
        controller: controller,
        validator: (val) {
          if (required && val.isEmpty) {
            return TextString.fieldRequired;
          }
          if (validatorFun != null) {
            return validatorFun(val);
          }
        });
  }

  GestureDetector buildDatePicker(Function selectedDate, bool required, BuildContext context, TextEditingController controller, String label) {
    return GestureDetector(
      onTap: () => selectedDate(context, controller),
      child: AbsorbPointer(
        child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.datetime,
            validator: (val) {
              if (required && val.isEmpty) {
                return TextString.fieldRequired;
              }
            },
            decoration: InputDecoration(
                labelText: label,
                prefixIcon: Icon(
                    Icons.dialpad,
                    color: AppColors.primaryColor
                ),
                labelStyle: TextStyle(color: AppColors.placeholderColor)),
            textAlign: TextAlign.left,
            style: TextStyle(color: AppColors.textColor, fontSize: 20.0)
        ),
      ),
    );
  }

}
