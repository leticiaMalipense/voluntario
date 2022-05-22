import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:queroservoluntario/components/app_bar_home.dart';
import 'package:queroservoluntario/components/loading.dart';
import 'package:queroservoluntario/components/loading_pagination.dart';
import 'package:queroservoluntario/models/job_model.dart';
import 'package:queroservoluntario/models/user_model.dart';
import 'package:queroservoluntario/services/auth_service.dart';
import 'package:queroservoluntario/services/job_service.dart';
import 'package:queroservoluntario/utils/app_style.dart';
import 'package:queroservoluntario/utils/text_string.dart';
import 'package:queroservoluntario/utils/validate_fields.dart';
import 'package:queroservoluntario/view/individual/subscription_page.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  JobService _jobService = JobService();
  AuthService _authService = AuthService();

  List<JobModel> jobs;
  UserModel user;

  TextEditingController cityController = TextEditingController();

  bool loading = true;
  bool loadingJob = true;

  int page = 0;
  int totalPage = 0;
  bool _isLoadMoreRunning = false;
  bool _hasNextPage = true;
  ScrollController _controller;

  @override
  Future<void> initState() {
    super.initState();
    _controller = new ScrollController()..addListener(_loadMore);
    _authService.getUser().then((response) => {
          if(response != null) {
            this.user = response,
            refreshPage(),
            this.cityController.text = this.user.address.city,
            loadFirst()
          }
        });
  }

  Future<Set<void>> loadFirst() {
    return _jobService
        .getByFilters(this.user.address.stateId, this.cityController.text, 0)
        .then((response) => {
              if (response != null)
                {
                  this.jobs = response.items,
                  totalPage = response.totalPage,
                  if (this.mounted)
                    {
                      setState(() {
                        this.loadingJob = false;
                      })
                    }
                }
              else if (response == null && page == 0)
                {
                  jobs = [],
                  setState(() {
                    this.loadingJob = false;
                    this._isLoadMoreRunning = false;
                  })
                }
            });
  }

  Future<Set<void>> load(int page) {
    return _jobService
        .getByFilters(this.user.address.stateId, this.cityController.text, page)
        .then((response) => {
              if (response != null)
                {
                  jobs.addAll(response.items),
                  setState(() {
                    this.loadingJob = false;
                    this._isLoadMoreRunning = false;
                  })
                }
              else if (response == null && page == 0)
                {
                  jobs = [],
                  setState(() {
                    this.loadingJob = false;
                    this._isLoadMoreRunning = false;
                  })
                }
            });
  }

  void refreshPage() {
    if (this.mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarHomeComponent.buildAppBar(context),
        backgroundColor: AppColors.backgroudColor,
        body: Container(
          child: loading ? Loading() : buildContainer(),
        ));
  }

  Container buildContainer() {
    return Container(
        child: Column(children: [
      Padding(
        padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 5.0),
        child: Container(
            child: Text(
          "Estado " + this.user.address.stateName,
          textAlign: TextAlign.left,
          style: TextStyle(color: AppColors.textColor, fontSize: 20.0),
        )),
      ),
      Padding(
          padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 5.0),
          child: Container(
              height: 50.0,
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: "",
                    labelStyle: TextStyle(color: AppColors.placeholderColor),
                    suffixIcon: IconButton(
                      onPressed: seachWithNewFilter,
                      icon: Icon(Icons.search),
                    )),
                textAlign: TextAlign.left,
                style: TextStyle(color: AppColors.textColor, fontSize: 20.0),
                controller: cityController,
              ))),
      loadingJob ? Loading() : buildListView(),
      LoadingPagination.loadCirular(this._isLoadMoreRunning),
    ]));
  }

  Function seachWithNewFilter() {
    this.page = 0;
    this._hasNextPage = true;
    setState(() {
      loadingJob = true;
    });
    loadFirst();
  }

  Widget buildListView() {
    return Expanded(
        child: ListView.separated(
      controller: _controller,
      padding: EdgeInsets.all(0.0),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 0,
        );
      },
      itemCount: jobs != null ? jobs.length : 0,
      itemBuilder: (context, index) {
        return Container(
          child: Padding(
            padding: EdgeInsets.only(
                top: 20.0, left: 20.0, right: 20.0, bottom: 10.0),
            child: ListTile(
              title: Text(jobs[index].title,
                  style: TextStyle(fontSize: 20.0, color: Colors.black)),
              subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ValidateFields.formaterDateToShow(
                        jobs[index].dateInitial)),
                    Text(ValidateFields.formaterDateToShow(
                        jobs[index].dateFinal))
                  ]),
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => SubscriptionPage(jobs[index])));
              },
            ),
          ),
        );
      },
    ));
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        loading == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        this._isLoadMoreRunning =
            true; // Display a progress indicator at the bottom
      });
      page += 1; // Increase _page by 1
      try {
        await load(page);
        if (page == totalPage) {
          setState(() {
            _hasNextPage = false;
            this._isLoadMoreRunning = false;
          });
        }
      } catch (err) {
        print(TextString.erroPagination);
      }
    }
  }
}
