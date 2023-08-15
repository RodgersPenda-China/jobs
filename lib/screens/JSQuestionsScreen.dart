import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:job_search/components/JSReviewComponent.dart';
import 'package:job_search/model/JSPopularCompanyModel.dart';
import 'package:job_search/utils/JSConstant.dart';
import 'package:job_search/utils/JSWidget.dart';
import 'package:job_search/main.dart';

import '../utils/JSColors.dart';
import '../utils/JSImage.dart';


class JSQuestionsScreen extends StatefulWidget {
  final JSPopularCompanyModel? popularCompanyList;

  JSQuestionsScreen({this.popularCompanyList});

  @override
  _JSQuestionsScreenState createState() => _JSQuestionsScreenState();
}

class _JSQuestionsScreenState extends State<JSQuestionsScreen> {

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: jsAppBar(context, notifications: false, message: false, bottomSheet: false, backWidget: true, homeAction: false,),
      body:SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Image.asset(js_SplashImage, height: 100, color: appStore.isDarkModeOn ? white : js_primaryColor),
              ),
              JSReviewComponent(),
            ],
          ),
        )
      )
      ;
  }
}
