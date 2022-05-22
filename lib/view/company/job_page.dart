import 'package:flutter/material.dart';
import 'package:queroservoluntario/components/app_bar_home.dart';
import 'package:queroservoluntario/components/dialog_message.dart';
import 'package:queroservoluntario/components/loading.dart';
import 'package:queroservoluntario/components/loading_pagination.dart';
import 'package:queroservoluntario/models/job_model.dart';
import 'package:queroservoluntario/services/job_service.dart';
import 'package:queroservoluntario/utils/app_style.dart';
import 'package:queroservoluntario/utils/text_string.dart';
import 'package:queroservoluntario/utils/validate_fields.dart';
import 'package:queroservoluntario/view/company/signup_job_page.dart';

class JobPage extends StatefulWidget {
  @override
  _JobPageState createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  JobService _jobService = JobService();
  List<JobModel> jobs;
  bool loading = true;

  int page = 0;
  int totalPage = 0;
  bool _isLoadMoreRunning = false;
  bool _hasNextPage = true;
  ScrollController _controller;

  @override
  Future<void> initState() {
    super.initState();
    loadFirst();
    _controller = new ScrollController()..addListener(_loadMore);
  }

  void loadFirst() {
    _jobService.getAllJobByCompany(0).then((response) => {
        if(response != null) {
          jobs = response.items, totalPage = response.totalPage, refreshPage()
        } else {
          refreshPage()
        }
    });
  }

  void load(int page) {
    _jobService.getAllJobByCompany(page).then((response) => {
          if (response != null)
            {
              jobs.addAll(response.items),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(new MaterialPageRoute<Null>(
                builder: (BuildContext context) {
                  return SignupJobPage(null);
                },
                fullscreenDialog: true));
          },
          child: const Icon(Icons.add),
          backgroundColor: AppColors.primaryColor,
        ),
        body: loading ? Loading() : buildContainer());
  }

  Container buildContainer() {
    return Container(
        child: Column(
      children: [
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
            itemCount: jobs != null ? jobs.length : 0,
            itemBuilder: (context, index) {
              return Dismissible(
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                ),
                key: Key(jobs[index].title),
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
                              builder: (context) =>
                                  SignupJobPage(jobs[index])));
                    },
                  ),
                ),
                onDismissed: (direction) {
                  _jobService.deleteJobById(jobs[index].id).then((value) => {
                        if (value != 200)
                          {
                            setState(() {
                              DialogMessage().showErroMessage(
                                  context, TextString.messageErro, false);
                            }),
                          }
                        else
                          {
                            setState(() {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      "${jobs[index].title} foi removido")));
                              jobs.removeAt(index);
                            }),
                          }
                      });
                },
              );
            },
          ),
        ),
        LoadingPagination.loadCirular(this._isLoadMoreRunning),
      ],
    ));
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        loading == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        this._isLoadMoreRunning = true; // Display a progress indicator at the bottom
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
