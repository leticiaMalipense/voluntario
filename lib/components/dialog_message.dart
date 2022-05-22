import 'package:flutter/material.dart';
import 'package:queroservoluntario/services/navigation_service.dart';
import 'package:queroservoluntario/view/initial/initial.dart';

class DialogMessage {

  void showErroMessage(BuildContext context, String text, bool pop) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(text),
        actions: <Widget>[
          FlatButton(onPressed: () => Navigator.pop(ctx), child: Text("Ok"))
        ],
      ),
    );
    if(pop) {
      Navigator.pop(context);
    }
  }

  void showSuccessMessage(BuildContext context, String text, bool pop, { bool reset }) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(text),
        actions: <Widget>[
          FlatButton(onPressed: () => Navigator.pop(ctx), child: Text("Ok"))
        ],
      ),
    );
    if(reset) {
      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute<Null>(
              builder: (BuildContext context) => Initial()),
              (Route<dynamic> route) => false);
    }
    else if(pop) {
      Navigator.pop(context);
    }
  }
}