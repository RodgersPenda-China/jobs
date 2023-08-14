import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:job_search/components/JSDrawerScreen.dart';
import 'package:job_search/components/JSFilteredResultsComponent.dart';
import 'package:job_search/model/JSPopularCompanyModel.dart';
import 'package:job_search/screens/JSCompanyProfileScreen.dart';
import 'package:job_search/screens/JSQuestionsScreen.dart';
import 'package:job_search/screens/JSReviewsScreen.dart';
import 'package:job_search/utils/JSColors.dart';
import 'package:job_search/utils/JSImage.dart';
import 'package:job_search/utils/JSWidget.dart';
import 'package:job_search/main.dart';
import 'package:http/http.dart' as http;

import 'JSHomeScreen.dart';

class JSCompanyProfileScreens extends StatefulWidget {
  //final JSPopularCompanyModel? popularCompanyList;
  final String id;  int employer;

 JSCompanyProfileScreens({required this.id,required this.employer});

  @override
  _JSCompanyProfileScreensState createState() => _JSCompanyProfileScreensState();
}

class _JSCompanyProfileScreensState extends State<JSCompanyProfileScreens> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  TabController? controller;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    make_https();
  }
  var jobs = {};

  make_https() async {
    String url = '';
    if(widget.employer == 0) {
       url = "https://x.smartbuybuy.com/job/index.php?get_company=1&id=${widget
          .id}";
    } else {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      url = "https://x.smartbuybuy.com/job/index.php?get_company=1&token=${token}";
    }
    print(url);
    setState(() {
      loading = true;
    });
    final response = await http.get(Uri.parse(url));
    setState(() {
      loading = false;
      jobs = json.decode(response.body);
    });
    // var jobs = ;
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
      length: 3,
      child: Scaffold(
        key: scaffoldKey,
        drawer: JSDrawerScreen(),
        appBar: jsAppBar(context, notifications: true, message: true, bottomSheet: true, backWidget: true, homeAction: true, callBack: () {
          setState(() {});
          scaffoldKey.currentState!.openDrawer();
        }),
        body:loading?Center( child: CircularProgressIndicator(color: Colors.blue,)): Column(
          children: [
            Container(
              color: js_primaryColor,
              padding: EdgeInsets.all(16),
              child:  Column(
                children: [
                  Row(
                    children: [
                      commonCachedNetworkImage(jobs['user'][0]['image'], height: 50, width: 50, fit: BoxFit.cover),
                      16.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child:                           Text(jobs['user'][0]['long_name'], style: boldTextStyle(color: white)),
                            width: 200,
                          ),
                          8.height,
                          Row(
                            children: [
                                  Icon(Icons.location_on_outlined, color: white, size: 16),
                              Text(jobs['user'][0]['location'],style: boldTextStyle(color: white))


                          ]),
                        ],
                      ),
                    ],
                  ),
                  16.height,
                  Row(
                    children: [
                      Icon(Icons.email),
                      Text(jobs['user'][0]['email']),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.call),
                      Text(jobs['user'][0]['phone']),
                    ],
                  ),
                  ],
              ),
            ),
            16.height,
            TabBar(
              labelColor: appStore.isDarkModeOn ? white : black,
              unselectedLabelColor: gray,
              isScrollable: true,
              indicatorColor: js_primaryColor,
              tabs: [
                Tab(
                  child: Text("Profile", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                Tab(
                  child: Text("Jobs", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),

                ),
                Tab(
                  child: Text("Photos", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),

                ),
              ],
              controller: controller,
            ),
            TabBarView(children: [
              SingleChildScrollView(
                  child: Container(
                    child:  Container(
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.all(16),
                      decoration: boxDecorationWithRoundedCorners(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(spreadRadius: 0.6, blurRadius: 1, color: gray.withOpacity(0.5)),
                        ],
                        backgroundColor: context.scaffoldBackgroundColor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HtmlWidget(
                            // the first parameter (`html`) is required
                            jobs['user'][0]['description'],

                            // all other parameters are optional, a few notable params:

                            // specify custom styling for an element
                            // see supported inline styling below
                            customStylesBuilder: (element) {
                              //if (element.classes.contains('foo')) {
                              return {'fontSize': '60'};
                              // }

                              return null;
                            },


                            // these callbacks are called when a complicated element is loading
                            // or failed to render allowing the app to render progress indicator
                            // and fallback widget
                            onErrorBuilder: (context, element, error) => Text('$element error: $error'),
                            onLoadingBuilder: (context, element, loadingProgress) => CircularProgressIndicator(),

                            // this callback will be triggered when user taps a link
                            // onTapUrl: (url) => print('tapped $url'),

                            // select the render mode for HTML body
                            // by default, a simple `Column` is rendered
                            // consider using `ListView` or `SliverList` for better performance
                            renderMode: RenderMode.column,

                            // set the default styling for text
                            textStyle: TextStyle(fontSize: 15),

                            // turn on `webView` if you need IFRAME support (it's disabled by default)
                            //webView: true,
                          ),
                          300.height

                        ],
                      ),
                    ),
                  )
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    for(int i = 0; i < jobs['job'].length;i++)
                      Container(
                        decoration: boxDecorationWithRoundedCorners(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(spreadRadius: 0.6, blurRadius: 1, color: gray.withOpacity(0.5)),
                          ],
                          backgroundColor: context.scaffoldBackgroundColor,
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("new", style: primaryTextStyle(size: 14)),
                                Icon(
                                  1 == 0 ? Icons.favorite : Icons.favorite_border,
                                  size: 20,
                                  color: 1 == 1
                                      ? js_primaryColor
                                      : appStore.isDarkModeOn
                                      ? white
                                      : black,
                                ).onTap(() {
                                  //filteredResultsList[i].selectSkill = !filteredResultsList[i].selectSkill.validate();
                                  setState(() {});
                                }),
                              ],
                            ),
                            8.height,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(jobs['job'][i]['name'], style: boldTextStyle()),
                                8.width,
                                Icon(Icons.block, size: 20).onTap(() {
                                  //filteredResultsList[i].isBlocked = !filteredResultsList[i].isBlocked.validate();
                                  setState(() {});
                                }),
                              ],
                            ),
                            4.height,
                            Text(jobs['job'][i]['city'], style: primaryTextStyle()),
                            4.height,
                            Text("Remote: ${jobs['job'][i]['remote']}", style: primaryTextStyle()),
                            8.height,
                            Container(
                              decoration: boxDecorationRoundedWithShadow(
                                8,
                                backgroundColor: appStore.isDarkModeOn ? scaffoldDarkColor : js_backGroundColor,
                              ),
                              padding: EdgeInsets.all(8),
                              //width: 165,
                              child: Row(
                                children: [
                                  Icon(Icons.payment, size: 18),
                                  4.width,
                                  Text(
                                    'ZK'+jobs['job'][i]['salary']+'/Month',
                                    style: boldTextStyle(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ).flexible(),
                                ],
                              ),
                            ),
                            16.height,
                            Row(
                              children: [
                                Icon(Icons.work, size: 18, color: js_primaryColor),
                                4.width,
                                Text("${jobs['job'][i]['experience']} Years Working Experience", style: secondaryTextStyle()),
                              ],
                            ),
                            8.height,
                            Row(
                              children: [
                                Icon(Icons.school, size: 18, color: Colors.red),
                                4.width,
                                Text("${jobs['job'][i]['education']}", style: secondaryTextStyle()),
                              ],
                            ),
                            8.height,
                            Row(
                              children: [
                                Icon(Icons.watch_later_outlined, size: 18, color: gray.withOpacity(0.8)),
                                4.width,
                                Text("${jobs['job'][i]['kind']}", style: secondaryTextStyle()),
                              ],
                            ),
                            16.height,
                            Text('Today', style: secondaryTextStyle()),
                          ],
                        ),
                      ).onTap(() {
                        // Add BottomSheet Code
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                          ),
                          builder: (context) {
                            return
                              FractionallySizedBox(
                                heightFactor: 0.90,
                                child: Stack(
                                  children: [
                                    SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Align(
                                                alignment: Alignment.center,
                                                child: Container(
                                                  width: 30,
                                                  height: 5,
                                                  decoration: boxDecorationWithRoundedCorners(
                                                    borderRadius: BorderRadius.circular(4),
                                                    backgroundColor: appStore.isDarkModeOn ? white : black,
                                                  ),
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.only(top: 16, left: 24),
                                                ),
                                              ).expand(),
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: IconButton(
                                                  onPressed: () {
                                                    finish(context);
                                                  },
                                                  padding: EdgeInsets.all(16),
                                                  icon: Icon(Icons.file_upload_outlined, size: 26),
                                                  alignment: Alignment.topRight,
                                                ),
                                              ),
                                            ],
                                          ),
                                          32.height,
                                          Text(jobs['job'][i]['name'], style: boldTextStyle(size: 22)),
                                          8.height,
                                          Text('Company Short Name', style: primaryTextStyle()),
                                          8.height,
                                          Text('${jobs['job'][i]['city']} . ${jobs['job'][i]['remote'] == 'no'?'Remote':'Online'}', style: primaryTextStyle()),
                                          8.height,
                                          Container(
                                              padding: EdgeInsets.all(8),
                                              decoration: boxDecorationWithRoundedCorners(
                                                backgroundColor: appStore.isDarkModeOn ? scaffoldDarkColor : js_backGroundColor,
                                              ),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(Icons.work, size: 18, color: js_primaryColor),
                                                      4.width,
                                                      Text("${jobs['job'][i]['experience']} Years Working Experience", style: secondaryTextStyle()),
                                                    ],
                                                  ),
                                                  8.height,
                                                  Row(
                                                    children: [
                                                      Icon(Icons.school, size: 18, color: Colors.red),
                                                      4.width,
                                                      Text(jobs['job'][i]['education'], style: secondaryTextStyle()),
                                                    ],
                                                  ),
                                                  8.height,
                                                  Row(
                                                    children: [
                                                      Icon(Icons.watch_later_outlined, size: 18, color: gray.withOpacity(0.8)),
                                                      4.width,
                                                      Text(jobs['job'][i]['kind'], style: secondaryTextStyle()),
                                                    ],
                                                  ),
                                                ],
                                              )),

                                          24.height,
                                          Text("Job details", style: boldTextStyle(size: 20)),
                                          16.height,
                                          Text("Salary", style: boldTextStyle()),
                                          4.height,
                                          Text('ZK${jobs['job'][i]['salary']}/Month', style: primaryTextStyle()),
                                          16.height,
                                          Text("Job type", style: boldTextStyle()),
                                          4.height,
                                          jsGetPrimaryTitle(jobs['job'][i]['kind']),
                                          4.height,
                                          jsGetPrimaryTitle(jobs['job'][i]['category']),
                                          4.height,
                                          jsGetPrimaryTitle(jobs['job'][i]['remote'] == 'no'?'Remote':'Online'),
                                          4.height,
                                          Divider(),
                                          16.height,
                                          Text("Full Job Description", style: boldTextStyle(size: 20)),
                                          16.height,
                                          HtmlWidget(
                                            // the first parameter (`html`) is required
                                            jobs['job'][i]['description'],

                                            // all other parameters are optional, a few notable params:

                                            // specify custom styling for an element
                                            // see supported inline styling below
                                            customStylesBuilder: (element) {
                                              //if (element.classes.contains('foo')) {
                                              return {'fontSize': '60'};
                                              // }

                                              return null;
                                            },


                                            // these callbacks are called when a complicated element is loading
                                            // or failed to render allowing the app to render progress indicator
                                            // and fallback widget
                                            onErrorBuilder: (context, element, error) => Text('$element error: $error'),
                                            onLoadingBuilder: (context, element, loadingProgress) => CircularProgressIndicator(),

                                            // this callback will be triggered when user taps a link
                                            // onTapUrl: (url) => print('tapped $url'),

                                            // select the render mode for HTML body
                                            // by default, a simple `Column` is rendered
                                            // consider using `ListView` or `SliverList` for better performance
                                            renderMode: RenderMode.column,

                                            // set the default styling for text
                                            textStyle: TextStyle(fontSize: 15),

                                            // turn on `webView` if you need IFRAME support (it's disabled by default)
                                            //webView: true,
                                          ),
                                        ],
                                      ).paddingOnly(left: 16,right: 16,bottom: 80),
                                    ),
                                    Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 8,
                                      child: AppButton(
                                        onTap: () {
                                          JSHomeScreen().launch(context);
                                        },
                                        width: MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.all(16),
                                        color: js_primaryColor,
                                        child: Text("Apply Now", style: boldTextStyle(color: white)),
                                      ),
                                    )
                                  ],
                                ),
                              );
                          },
                        );
                      })
                  ],
                ),
              ),
              JSFilteredResultsComponent(),
            ]).expand(),
          ],
        ),
      ),
    );
  }
}
