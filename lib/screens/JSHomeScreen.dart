import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:job_search/components/JSDrawerScreen.dart';
import 'package:job_search/components/JSFilteredResultsComponent.dart';
import 'package:job_search/screens/JSRecentSearchesScreen.dart';
import 'package:job_search/utils/JSColors.dart';
import 'package:job_search/utils/JSConstant.dart';
import 'package:job_search/utils/JSWidget.dart';
import 'package:job_search/main.dart';


class JSHomeScreen extends StatefulWidget {
  const JSHomeScreen({Key? key}) : super(key: key);

  @override
  _JSHomeScreenState createState() => _JSHomeScreenState();
}

class _JSHomeScreenState extends State<JSHomeScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  TabController? controller;

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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: scaffoldKey,
        drawer: JSDrawerScreen(),
        appBar: jsAppBar(context, notifications: true, message: true, bottomSheet: true, backWidget: false, homeAction: false, callBack: () {
          setState(() {});
          scaffoldKey.currentState!.openDrawer();
        }),
        body: Column(
          children: [
            Container(
              height: textFieldHeight,
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 24),
              decoration: boxDecoration(radius: 8, color: appStore.isDarkModeOn ? scaffoldDarkColor : white),
              child: AppTextField(
                textFieldType: TextFieldType.NAME,
                decoration: jsInputDecoration(
                  hintText: "Search for jobs title, keyword or company",
                  prefixIcon: Icon(Icons.search,color: context.iconColor,size: 20),
                ),
              ),
            ),
            Container(height: 10, color: appStore.isDarkModeOn ? scaffoldDarkColor : js_backGroundColor),
            8.height,
            TabBar(
              labelColor: appStore.isDarkModeOn ? white : black,
              unselectedLabelColor: gray,
              isScrollable: false,
              indicatorColor: js_primaryColor,
              tabs: [
                Tab(child: Text("Job feed", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                Tab(child: Text("Recent searches", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
              ],
              controller: controller,
            ),
            TabBarView(
              children: [
                JSFilteredResultsComponent(),
                JSRecentSearchesScreen(),
              ],
            ).expand(),
          ],
        ),
      ),
    );
  }
}
