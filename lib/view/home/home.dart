import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:queroservoluntario/enums/user_type.dart';
import 'package:queroservoluntario/services/preference_service.dart';
import 'package:queroservoluntario/utils/app_style.dart';
import 'package:queroservoluntario/view/company/application_company_page.dart';
import 'package:queroservoluntario/view/individual/application_page.dart';
import 'package:queroservoluntario/view/profile/profile_page.dart';

import '../individual/feed_page.dart';
import '../company/job_page.dart';

class Home extends StatefulWidget {
  int selectedPage;
  Home(int selectedPage) {
      this.selectedPage = selectedPage;
  }
  @override
  _HomeState createState() => _HomeState(this.selectedPage);
}

class _HomeState extends State<Home> {
  int selectedPage;
  String userType;

  _HomeState(int selectedPage){
    this.selectedPage = selectedPage;
  }

  final _pageIndividualOptions = [FeedPage(), ApplicationPage(), ProfilePage()];

  final _pageCompanyOptions = [
    JobPage(),
    ApplicationCompanyPage(),
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    userType =
        PreferenceService().getPreferenceByKey(PreferenceService.USER_PROFILE);

    return Scaffold(
      backgroundColor: AppColors.backgroudColor,
      bottomNavigationBar: isIndividual()
          ? buildBottomNavigationBar(IndividualCompany())
          : buildBottomNavigationBar(menuCompany()),
      body: isIndividual()
          ? _pageIndividualOptions[selectedPage]
          : _pageCompanyOptions[selectedPage],
    );
  }

  bool isIndividual() =>
      userType == UserTypeHelper.getValue(UserType.INDIVIDUAL).toString();

  BottomNavigationBar buildBottomNavigationBar(
      List<BottomNavigationBarItem> items) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      currentIndex: selectedPage,
      onTap: (index) {
        setState(() {
          selectedPage = index;
        });
      },
      items: items,
    );
  }

  List<BottomNavigationBarItem> menuCompany() {
    return [
      BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label:
            'VAGAS',
          ),
      BottomNavigationBarItem(
        icon: Icon(Icons.list),
        label: 'APLICADAS',
      ),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: 'PERFIL'),
    ];
  }

  List<BottomNavigationBarItem> IndividualCompany() {
    return [
      BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label:
            'FEED',
          ),
      BottomNavigationBarItem(
        icon: Icon(Icons.list),
        label: 'APLICADAS',
      ),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: 'PERFIL'),
    ];
  }
}
