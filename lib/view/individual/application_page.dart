import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:queroservoluntario/components/app_bar_home.dart';
import 'package:queroservoluntario/components/loading.dart';
import 'package:queroservoluntario/components/loading_pagination.dart';
import 'package:queroservoluntario/models/job_model.dart';
import 'package:queroservoluntario/models/subscription_model.dart';
import 'package:queroservoluntario/services/subscription_service.dart';
import 'package:queroservoluntario/utils/app_style.dart';
import 'package:queroservoluntario/utils/text_string.dart';
import 'package:queroservoluntario/utils/validate_fields.dart';
import 'package:queroservoluntario/view/individual/subscription_page.dart';

class ApplicationPage extends StatefulWidget {
  @override
  _ApplicationPageState createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {
  SubscriptionService _subscriptionService = SubscriptionService();

  List<SubscriptionModel> subscriptions;
  bool loading = true;

  int page = 0;
  int totalPage = 0;
  bool _isLoadMoreRunning = false;
  bool _hasNextPage = true;
  ScrollController _controller;

  @override
  void initState() {
    super.initState();
    loadFirst();
    _controller = new ScrollController()..addListener(_loadMore);
  }

  void loadFirst() {
    _subscriptionService.getByUserId(0).then((response) => {
          if (response != null)
            {
              this.subscriptions = response.items,
              totalPage = response.totalPage,
              refreshPage()
            }
          else
            {refreshPage()}
        });
  }

  void load(int page) {
    _subscriptionService.getByUserId(page).then((response) => {
          if (response != null)
            {
              this.subscriptions.addAll(response.items),
              setState(() {
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
        body: Container(child: loading ? Loading() : buildContainer()));
  }

  Container buildContainer() {
    return Container(
        child: Column(children: [
      Expanded(
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
        itemCount: subscriptions != null ? subscriptions.length : 0,
        itemBuilder: (context, index) {
          return Container(
            child: Padding(
              padding: EdgeInsets.only(
                  top: 20.0, left: 20.0, right: 20.0, bottom: 10.0),
              child: ListTile(
                title: Text(subscriptions[index].title,
                    style: TextStyle(fontSize: 20.0, color: Colors.black)),
                subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ValidateFields.formaterDateToShow(
                          subscriptions[index].dateInitial)),
                      Text(ValidateFields.formaterDateToShow(
                          subscriptions[index].dateFinal))
                    ]),
                onTap: () {
                  JobModel jobModel = JobModel();
                  jobModel.id = subscriptions[index].jobId;
                  jobModel.subscriptionId = subscriptions[index].id;
                  jobModel.load = true;
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => SubscriptionPage(jobModel)));
                },
              ),
            ),
          );
        },
      )),
      LoadingPagination.loadCirular(this._isLoadMoreRunning),
    ]));
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
