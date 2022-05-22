import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:queroservoluntario/components/app_bar.dart';
import 'package:queroservoluntario/utils/app_style.dart';

class Information extends StatefulWidget {
  @override
  _InformationState createState() => _InformationState();
}

class _InformationState extends State<Information> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarComponent.buildAppBar(context),
        backgroundColor: AppColors.backgroudColor,
        body: Column(
          children: [
            Padding(
                padding: EdgeInsets.all(20.0),
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text:
                              "O aplicativo \"Quero ser voluntário\" é uma ferramenta que tem o objetivo de apresentar às pessoas que acreditam no futuro de milhares de pessoas que hoje se encontram vinculadas a alguma entidade de assistência, onde e como elas podem contribuir para que esse trabalho de extrema importância continue cada vez mais fazendo a diferença na nossa sociedade.\n\n",
                          style: TextStyle(
                              color: Colors.black, fontSize: 18.0, height: 1.5),
                        ),
                        TextSpan(
                          text:
                              "Somos uma plataforma totalmente online, sem fins lucrativos, disponível para android e ios.\n",
                          style: TextStyle(
                              color: Colors.black, fontSize: 18.0, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ))
          ],
        ));
  }
}
