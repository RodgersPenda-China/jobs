import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:job_search/screens/user.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:job_search/screens/JSCompleteProfileOneScreen.dart';
import 'package:job_search/screens/JSEnableNotificationDialog.dart';
import 'package:job_search/utils/JSColors.dart';
import 'package:job_search/utils/JSImage.dart';
import 'package:job_search/utils/JSWidget.dart';
import 'package:job_search/main.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../components/JSDrawerScreen.dart';
import '../controller/home.dart';
import 'JSCompanyProfileScreens.dart';

class JSMessagesScreen extends StatefulWidget {
  const JSMessagesScreen({Key? key}) : super(key: key);

  @override
  _JSMessagesScreenState createState() => _JSMessagesScreenState();
}

class _JSMessagesScreenState extends State<JSMessagesScreen> {
  var toYearItems = ['Inbox', 'Archive', 'Spam'];
  TabController? controller;

  String toYearValue = 'Inbox';

  @override
  void initState() {
    super.initState();
    make_https();
  }
  var messages = {};
  int role = 0;
  make_https() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    role = prefs.getInt('role')!;
    String url = '';
      url = "http://api.ioevisa.net/api/job/index.php?get_message=1&role=${role}&token=${token}";
    setState(() {
      loading = true;
    });
    print(url);
    final response = await http.get(Uri.parse(url));
    setState(() {
      loading = false;
      messages = json.decode(response.body);
    });
    print('object');
    // var jobs = ;
  }
  bool loading = false;

  void init() async {
    //
  }
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

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
          appBar: jsAppBar(context, backWidget: true, homeAction: true, message: false, notifications: false, bottomSheet: true, callBack: () {
            setState(() {});
            scaffoldKey.currentState!.openDrawer();
          }),
          body: GetBuilder<HomeController>(builder: (authController){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                16.height,
                TabBar(
                  labelColor: appStore.isDarkModeOn ? white : black,
                  unselectedLabelColor: gray,
                  isScrollable: false,
                  indicatorColor: js_primaryColor,
                  tabs: [
                    Tab(child: Text("${role == 0?'Applied Jobs':'Candidates'}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                    Tab(child: Text("${role == 0?'Received Invites':'Applicants'}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                  ],
                  controller: controller,
                ),
                TabBarView(
                  children: [
                    loading? Center(child: CircularProgressIndicator(color: Colors.blue,),):
                    messages['applied'].length == 0 && role == 0 || messages['candidate'].length == 0 && role == 1?
                    Center(child: Text('No Data Found'),):
                        role == 0?
                    ListView.separated(
                      itemCount: messages['applied'].length,
                      padding: EdgeInsets.all(8),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (BuildContext context, int index) => Divider(),
                      itemBuilder: (context, index) {
                        //JSPopularCompanyModel data = popularCompanyList[index];
                       var jobs = messages['applied'][index]['jobs'];

                        return  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: (){
                                var job = messages['applied'][index]['jobs'];
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
                                                  Text(jobs['name'], style: boldTextStyle(size: 22)),
                                                  8.height,
                                                  Text(jobs['short_name'], style: primaryTextStyle()),
                                                  8.height,
                                                  Text('${jobs['city']} . ${jobs['remote'] == 'Yes'?'Remote':'Online'}', style: primaryTextStyle()),
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
                                                              Text("${jobs['experience']} Years Working Experience", style: secondaryTextStyle()),
                                                            ],
                                                          ),
                                                          8.height,
                                                          Row(
                                                            children: [
                                                              Icon(Icons.school, size: 18, color: Colors.red),
                                                              4.width,
                                                              Text(jobs['education'], style: secondaryTextStyle()),
                                                            ],
                                                          ),
                                                          8.height,
                                                          Row(
                                                            children: [
                                                              Icon(Icons.watch_later_outlined, size: 18, color: gray.withOpacity(0.8)),
                                                              4.width,
                                                              Text(jobs['kind'], style: secondaryTextStyle()),
                                                            ],
                                                          ),
                                                        ],
                                                      )),
                                                  Card (
                                                    margin: EdgeInsets.all(10),
                                                    shadowColor: Colors.blueGrey,
                                                    elevation: 10,
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: <Widget>[

                                                        ListTile(
                                                          leading: GestureDetector(
                                                              onTap: (){},
                                                              child: CachedNetworkImage(
                                                                imageUrl: jobs['image'],
                                                                placeholder: (context, url) => CircularProgressIndicator(),
                                                                errorWidget: (context, url, error) => Icon(Icons.error),
                                                              )
                                                          ),
                                                          subtitle: GestureDetector(
                                                            onTap: (){
                                                              JSCompanyProfileScreens(id: jobs['user_id'],employer: 0,).launch(context);
                                                            },
                                                            child:Text("Other Jobs"),
                                                          ),
                                                          title:GestureDetector(
                                                              onTap: (){
                                                                JSCompanyProfileScreens(id: jobs['user_id'],employer: 0).launch(context);

                                                              },
                                                              child: Text(
                                                                jobs['short_name'],
                                                                style: TextStyle(fontSize: 20),
                                                              )),

                                                          trailing: GestureDetector(
                                                              onTap: (){
                                                                JSCompanyProfileScreens(id: jobs['user_id'],employer: 0).launch(context);

                                                              },
                                                              child:
                                                              GestureDetector(
                                                                  onTap: (){
                                                                    launchUrl(Uri.parse('https://www.google.com/maps/dir/?api=1&destination=${jobs['location']}&destination_place_id=${jobs['place_id']}'
                                                                    ),mode: LaunchMode.externalNonBrowserApplication,);
                                                                  },
                                                                  child:Icon (
                                                                      Icons.location_on,
                                                                      color: Colors.blue,
                                                                      size: 23
                                                                  ))),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  24.height,
                                                  Text("Job details", style: boldTextStyle(size: 20)),
                                                  16.height,
                                                  Text("Salary", style: boldTextStyle()),
                                                  4.height,
                                                  Text('ZK${jobs['salary']}/Month', style: primaryTextStyle()),
                                                  16.height,
                                                  Text("Job type", style: boldTextStyle()),
                                                  4.height,
                                                  jsGetPrimaryTitle(jobs['kind']),
                                                  4.height,
                                                  jsGetPrimaryTitle(jobs['category']),
                                                  4.height,
                                                  jsGetPrimaryTitle(jobs['remote'] == 'Yes'?'Remote':'Online'),
                                                  4.height,
                                                  Divider(),
                                                  16.height,
                                                  Text("Full Job Description", style: boldTextStyle(size: 20)),
                                                  16.height,
                                                  HtmlWidget(
                                                    // the first parameter (`html`) is required
                                                    jobs['description'],

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
                                          ],
                                        ),
                                      );
                                  },
                                );

                                //  JSCompanyProfileScreens(id: messages['applied'][index]['id'],employer: 0,).launch(context);
                                 },
                              child: Row(
                                children: [
                                  commonCachedNetworkImage(messages['applied'][index]['image'], height: 50, width: 50, fit: BoxFit.contain),
                                  16.width,
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(messages['applied'][index]['name'], style: boldTextStyle()),
                                      4.height,

                                      Row(
                                        children: [
                                          Container(
                                              width: 200,
                                              child:Text('Job: ${messages['applied'][index]['job']}', style: secondaryTextStyle(color: js_textColor.withOpacity(0.7)))

                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                              width: 200,
                                              child:Text('CV: ${messages['applied'][index]['cv']}', style: secondaryTextStyle(color: js_textColor.withOpacity(0.7)))

                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                            ,
                            6.height,
                            GestureDetector(
                            onTap: (){
                        launchUrl(Uri.parse('https://www.google.com/maps/dir/?api=1&destination=${messages['applied'][index]['location']}&destination_place_id=${messages['applied'][index]['location']}'
                        ),mode: LaunchMode.externalNonBrowserApplication,);
                        },
                        child:
                            Row(
                              children: [
                                Icon(Icons.location_on,color: Colors.blue,),
                                8.width,
                                Text('${messages['applied'][index]['location']}', style: secondaryTextStyle(color: Colors.blue)),
                              ],
                            )),
                          ],
                        ).onTap(() {
                          // JSCompanyProfileScreens(popularCompanyList: data).launch(context);
                        });
                      },
                    )
                            :
                        ListView.separated(
                          itemCount: messages['candidate'].length,
                          padding: EdgeInsets.all(8),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          separatorBuilder: (BuildContext context, int index) => Divider(),
                          itemBuilder: (context, index) {
                            //JSPopularCompanyModel data = popularCompanyList[index];

                            return  Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    UserScreen(id: messages['candidate'][index]['id'],applicant: 0,
                                        job_id: 0.toString()).launch(context);
                                    //JSCompanyProfileScreens(id: messages['candidate'][index]['id'],employer: 0,).launch(context);
                                  },
                                  child: Row(
                                    children: [
                                      commonCachedNetworkImage(messages['candidate'][index]['image'], height: 50, width: 50, fit: BoxFit.contain),
                                      16.width,
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(messages['candidate'][index]['name'], style: boldTextStyle()),
                                          4.height,

                                          Row(
                                            children: [
                                              Container(
                                                  width: 200,
                                                  child:Text('${messages['candidate'][index]['long_name']}', style: secondaryTextStyle(color: js_textColor.withOpacity(0.7)))

                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                                ,
                                6.height,
                            GestureDetector(
                            onTap: (){
                            launchUrl(Uri.parse('https://www.google.com/maps/dir/?api=1&destination=${messages['candidate'][index]['location']}&destination_place_id=${messages['candidate'][index]['place_id']}'
                            ),mode: LaunchMode.externalNonBrowserApplication,);
                            },
                            child:
                                Row(
                                  children: [
                                    Icon(Icons.location_on,color: Colors.blue,),
                                    8.width,
                                    Text('${messages['candidate'][index]['location']}', style: secondaryTextStyle(color: Colors.blue)),
                                  ],
                                )),
                              ],
                            ).onTap(() {
                              // JSCompanyProfileScreens(popularCompanyList: data).launch(context);
                            });
                          },
                        ),

                    loading? Center(child: CircularProgressIndicator(color: Colors.blue,),):
                    messages['candidate'].length == 0 && role == 0 || messages['applied'].length == 0 && role == 1?
                    Center(child: Text('No Data Found'),)
                        :role == 0?
                    ListView.separated(
                      itemCount: messages['candidate'].length,
                      padding: EdgeInsets.all(8),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (BuildContext context, int index) => Divider(),
                      itemBuilder: (context, index) {
                        //JSPopularCompanyModel data = popularCompanyList[index];

                        return  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: (){
                                JSCompanyProfileScreens(id: messages['candidate'][index]['id'],employer: 0,).launch(context);
                              },
                              child: Row(
                                children: [
                                  commonCachedNetworkImage(messages['candidate'][index]['image'], height: 50, width: 50, fit: BoxFit.contain),
                                  16.width,
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(messages['candidate'][index]['name'], style: boldTextStyle()),
                                      4.height,

                                      Row(
                                        children: [
                                          Container(
                                              width: 200,
                                              child:Text('${messages['candidate'][index]['long_name']}', style: secondaryTextStyle(color: js_textColor.withOpacity(0.7)))

                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                            ,
                            6.height,
                        GestureDetector(
                        onTap: (){
                        launchUrl(Uri.parse('https://www.google.com/maps/dir/?api=1&destination=${messages['candidate'][index]['location']}&destination_place_id=${messages['candidate'][index]['place_id']}'
                        ),mode: LaunchMode.externalNonBrowserApplication,);
                        },
                        child:
                            Row(
                              children: [
                                Icon(Icons.location_on,color: Colors.blue,),
                                8.width,
                                Text('${messages['candidate'][index]['location']}', style: secondaryTextStyle(color: Colors.blue)),
                              ],
                            )),
                          ],
                        ).onTap(() {
                          // JSCompanyProfileScreens(popularCompanyList: data).launch(context);
                        });
                      },
                    ):
                    ListView.separated(
                      itemCount: messages['applied'].length,
                      padding: EdgeInsets.all(8),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (BuildContext context, int index) => Divider(),
                      itemBuilder: (context, index) {
                        //JSPopularCompanyModel data = popularCompanyList[index];

                        return  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: (){
                                UserScreen(id: messages['applied'][index]['id'],applicant: 1,
                                    job_id: messages['applied'][index]['job_id']).launch(context);
                                // JSCompanyProfileScreens(id: messages['applied'][index]['id'],employer: 0,).launch(context);
                              },
                              child: Row(
                                children: [
                                  commonCachedNetworkImage(messages['applied'][index]['image'], height: 50, width: 50, fit: BoxFit.contain),
                                  16.width,
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(messages['applied'][index]['name'], style: boldTextStyle()),
                                      4.height,

                                      Row(
                                        children: [
                                          Container(
                                              width: 200,
                                              child:Text('Job: ${messages['applied'][index]['job']}', style: secondaryTextStyle(color: js_textColor.withOpacity(0.7)))

                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                              width: 200,
                                              child:Text('CV: ${messages['applied'][index]['cv']}', style: secondaryTextStyle(color: js_textColor.withOpacity(0.7)))

                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                            ,
                            6.height,
                            GestureDetector(
                            onTap: (){
                        launchUrl(Uri.parse('https://www.google.com/maps/dir/?api=1&destination=${messages['applied'][index]['location']}&destination_place_id=${messages['applied'][index]['place_id']}'
                        ),mode: LaunchMode.externalNonBrowserApplication,);
                        },
                        child:
                            Row(
                              children: [
                                Icon(Icons.location_on,color: Colors.blue,),
                                8.width,
                                Text('${messages['applied'][index]['location']}', style: secondaryTextStyle(color: Colors.blue)),
                              ],
                            )),
                          ],
                        ).onTap(() {
                          // JSCompanyProfileScreens(popularCompanyList: data).launch(context);
                        });
                      },
                    )
                  ],
                ).expand(),
              ],
            );
          })),
    );
  }
}
