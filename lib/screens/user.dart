import 'dart:convert';
import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
// import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:job_search/controller/api.dart';
import 'package:job_search/screens/workExperience.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:job_search/components/JSCvComponent.dart';
import 'package:job_search/components/JSDrawerScreen.dart';
import 'package:job_search/model/JSPopularCompanyModel.dart';
import 'package:job_search/utils/JSColors.dart';
import 'package:job_search/utils/JSDataGenerator.dart';
import 'package:job_search/utils/JSWidget.dart';
import 'package:job_search/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/JSReviewAndSaVeComponent.dart';
import '../controller/home.dart';
import '../model/user.dart';
import 'JSCompleteProfileOneScreen.dart';
import 'education.dart';
import 'package:http/http.dart' as http;
class UserScreen extends StatefulWidget {
  String id; int applicant;String job_id;
   UserScreen({Key? key,required this.id,required this.applicant,required this.job_id}) : super(key: key);

  @override
  _JSProfileScreenState createState() => _JSProfileScreenState();
}

class _JSProfileScreenState extends State<UserScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  List<JSPopularCompanyModel> reviewDraftList = getReviewDraftList();
  List<JSPopularCompanyModel> skillList = getSkillList();
  var add_response = {}; bool added = false;
  TabController? controller;
  bool candidate_loading = false;
  var job = {};
  @override
  void initState() {
    super.initState();
    init();
  }
  List<User> user = []; List<Work_Experience> work = [];bool user_loading = false;
  List<Education> edu = [];
  void init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String url = "http://api.ioevisa.net/api/job/index.php?get_user=1&id=${widget.id}&token=${token}";
    setState(() {
      loading = true; candidate_loading = true;
    });
    print(url);
    final response = await http.get(Uri.parse(url));
    if(widget.applicant == 0){
    setState(() {
      loading = false; candidate_loading = false;
      var _body = jsonDecode(response.body);
      user = UsersModel.fromJson(_body).user;
      work = UsersModel.fromJson(_body).work;
      edu = UsersModel.fromJson(_body).education;
      user_loading = false;
    });
    } else {
      setState(() {
        loading = false;
        var _body = jsonDecode(response.body);
        user = UsersModel.fromJson(_body).user;
        work = UsersModel.fromJson(_body).work;
        edu = UsersModel.fromJson(_body).education;
        user_loading = false;
        added = true;
      });
    }
    if(user[0].candidate == 'Yes'){
      setState(() {added = true;});
    }
    if(widget.applicant == 1) {
      setState(() {
        candidate_loading = true;
      });
      String job_url = "http://api.ioevisa.net/api/job/index.php?get_this_job=1&job=${widget.job_id}&id=${widget.id}";
      print(job_url);
      final response = await http.get(Uri.parse(job_url));
      setState(() {
        job = json.decode(response.body);
        candidate_loading = false;
      });
    }
    print('object');
  }



  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }
  bool loading = false;
  Future kl(BuildContext context,Work_Experience work){
    return showModalBottomSheet(
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
                      Text( work.title, style: boldTextStyle(size: 22)),
                      8.height,
                      Text('Position: '+ work.position, style: primaryTextStyle()),
                      8.height,
                      Text('${ work.work_from} - ${work.work_to}', style: primaryTextStyle()),
                      8.height,

                      24.height,
                      Text("Job details", style: boldTextStyle(size: 20)),
                      16.height,
                      Text("Company & Location", style: boldTextStyle()),
                      4.height,
                      Text('${ work.company}', style: primaryTextStyle()),
                      4.height,
                      Text('Location: ${ work.city}', style: primaryTextStyle(color: Colors.blue)),
                      16.height,
                      Text("Job type", style: boldTextStyle()),
                      4.height,
                      jsGetPrimaryTitle( work.work_type),
                      4.height,
                      jsGetPrimaryTitle( work.category)
                      ,4.height,
                      Divider(),
                      16.height,
                      Text("Full Job Description", style: boldTextStyle(size: 20)),
                      16.height,
                      HtmlWidget(
                        // the first parameter (`html`) is required
                        work.description,

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
  }
  Future ed(BuildContext context,Education work){
    return showModalBottomSheet(
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
                      Text( work.title, style: boldTextStyle(size: 22)),
                      8.height,
                      Text('Degree: '+ work.degree, style: primaryTextStyle()),
                      8.height,
                      Text('${ work.learn_from} - ${work.learn_to}', style: primaryTextStyle()),
                      8.height,

                      24.height,
                      Text("School details", style: boldTextStyle(size: 20)),
                      16.height,
                      Text("School & Location", style: boldTextStyle()),
                      4.height,
                      Text('${ work.school}', style: primaryTextStyle()),
                      4.height,
                      Text('Location: ${ work.city}', style: primaryTextStyle(color: Colors.blue)),
                      16.height,
                      Text("School type", style: boldTextStyle()),
                      4.height,
                      jsGetPrimaryTitle( work.school_type),
                      4.height,
                      jsGetPrimaryTitle( work.category)
                      ,4.height,
                      Divider(),
                      16.height,
                      Text(" Description", style: boldTextStyle(size: 20)),
                      16.height,
                      HtmlWidget(
                        // the first parameter (`html`) is required
                        work.description,

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
          floatingActionButton:
             widget.applicant == 1?
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: [
                     ElevatedButton(
                       onPressed: (){
                         launchUrl(Uri.parse(job['cv']),mode: LaunchMode.externalApplication);
                       },
                       style: ElevatedButton.styleFrom(
                           primary: js_primaryColor,
                           shape: StadiumBorder()// Background color
                       ),
                       child: candidate_loading?CircularProgressIndicator(color: Colors.white,):
                       Text(
                         'View CV',
                         style: TextStyle(fontSize: 18),
                       ),
                     ),
                     ElevatedButton(
                       onPressed: (){
                         if(loading == true){return;}
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
                                           Text(job['name'], style: boldTextStyle(size: 22)),
                                           8.height,
                                           Text('Company Short Name', style: primaryTextStyle()),
                                           8.height,
                                           Text('${job['city']} . ${job['remote'] == 'no'?'Remote':'Online'}', style: primaryTextStyle()),
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
                                                       Text("${job['experience']} Years Working Experience", style: secondaryTextStyle()),
                                                     ],
                                                   ),
                                                   8.height,
                                                   Row(
                                                     children: [
                                                       Icon(Icons.school, size: 18, color: Colors.red),
                                                       4.width,
                                                       Text(job['education'], style: secondaryTextStyle()),
                                                     ],
                                                   ),
                                                   8.height,
                                                   Row(
                                                     children: [
                                                       Icon(Icons.watch_later_outlined, size: 18, color: gray.withOpacity(0.8)),
                                                       4.width,
                                                       Text(job['kind'], style: secondaryTextStyle()),
                                                     ],
                                                   ),
                                                 ],
                                               )),

                                           24.height,
                                           Text("Job details", style: boldTextStyle(size: 20)),
                                           16.height,
                                           Text("Salary", style: boldTextStyle()),
                                           4.height,
                                           Text('ZK${job['salary']}/Month', style: primaryTextStyle()),
                                           16.height,
                                           Text("Job type", style: boldTextStyle()),
                                           4.height,
                                           jsGetPrimaryTitle(job['kind']),
                                           4.height,
                                           jsGetPrimaryTitle(job['category']),
                                           4.height,
                                           jsGetPrimaryTitle(job['remote'] == 'no'?'Remote':'Online'),
                                           4.height,
                                           Divider(),
                                           16.height,
                                           Text("Full Job Description", style: boldTextStyle(size: 20)),
                                           16.height,
                                           HtmlWidget(
                                             // the first parameter (`html`) is required
                                             job['description'],

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
                       },
                       style: ElevatedButton.styleFrom(
                           primary: js_primaryColor,
                           shape: StadiumBorder()// Background color
                       ),
                       child: candidate_loading?CircularProgressIndicator(color: Colors.white,):
                       Text(
                         'View Job',
                         style: TextStyle(fontSize: 18),
                       ),
                     )

                   ],
                 )
             :ElevatedButton(
                onPressed: () async {
                  if(added){return;}
                 // Add Candidate
                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                  String? token = prefs.getString('token'); String candidate_id = user[0].id;
                  String url = "http://api.ioevisa.net/api/job/index.php?add_candidate=1&token=${token}&candidate_id=${candidate_id}";
                  setState(() {
                    candidate_loading = true;
                  });
                  print(url);
                  final response = await http.get(Uri.parse(url));
                  var results = json.decode(response.body);
                  if(results['error'] == 0){
                    setState(() {
                      added = true;
                    });
                    final snackBar = SnackBar(
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        title: 'Success',
                        message:'Data Saved Successfully',
                        contentType: ContentType.success,
                      ),
                    );
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(snackBar);
                  } else {

                    if(results['error'] == 0){
                      final snackBar = SnackBar(
                        elevation: 0,
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          title: 'Error',
                          message:results['message'],
                          contentType: ContentType.failure,
                        ),
                      );
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(snackBar);
                    }

                  }
                  setState(() {candidate_loading = false;});

                },
                style: ElevatedButton.styleFrom(
                    primary: added?Colors.green:js_primaryColor,
                    shape: StadiumBorder()// Background color
                ),
                child: candidate_loading?CircularProgressIndicator(color: Colors.white,):
                Text(
                  added?'Added':'Add Candidate',
                  style: TextStyle(fontSize: 18),
                ),
              ),
          body: GetBuilder<HomeController>(builder: (authController){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                16.height,
                loading?Shimmer.fromColors(
                  baseColor: Colors.red,
                  highlightColor: Colors.blue,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: boxDecorationWithRoundedCorners(
                          boxShape: BoxShape.circle,
                          border: Border.all(color: js_primaryColor, width: 4),
                          backgroundColor: context.scaffoldBackgroundColor,
                        ),
                        padding: EdgeInsets.all(24),
                        child: Text('RP', style: boldTextStyle(size: 22)),
                      ),
                      16.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [Text('Loading', style: boldTextStyle(size: 22)),
                              IconButton(onPressed: () {}, icon: Icon(Icons.edit, color: js_primaryColor))],
                          ),
                          Row(
                            children: [
                              Icon(Icons.location_on, color:Theme.of(context).iconTheme.color),
                              8.width,
                              Text('Loading', style: boldTextStyle()),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.person, color: Theme.of(context).iconTheme.color),
                              8.width,
                              Text('Loading', style: boldTextStyle()),
                            ],
                          ),
                        ],
                      ).expand()
                    ],
                  ).paddingSymmetric(horizontal: 16, vertical: 16),
                ):

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 150,
                      decoration: boxDecorationWithRoundedCorners(
                        boxShape: BoxShape.circle,
                        border: Border.all(color: js_primaryColor, width: 4),
                        backgroundColor: context.scaffoldBackgroundColor,
                      ),
                      padding: EdgeInsets.all(24),
                      child: CachedNetworkImage(
                        imageUrl: user[0].image,
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    16.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 200,
                              child:                            Text(user[0].name, style: boldTextStyle(size: 22)),

                            ),
                            ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.location_on, color:Theme.of(context).iconTheme.color),
                            8.width,
            Container(
            width: 150,
            child:
            Text(user[0].location, style: boldTextStyle(color: Colors.blue)),)
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.person, color: Theme.of(context).iconTheme.color),
                            8.width,
                            Text(user[0].gender, style: boldTextStyle()),
                          ],
                        ),
                      ],
                    ).expand()
                  ],
                ).paddingSymmetric(horizontal: 16, vertical: 16),
                TabBar(
                  labelColor: appStore.isDarkModeOn ? white : black,
                  unselectedLabelColor: gray,
                  isScrollable: false,
                  indicatorColor: js_primaryColor,
                  tabs: [
                    Tab(child: Text("Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                    Tab(child: Text("Description", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                  ],
                  controller: controller,
                ),
                TabBarView(
                  children: [
                    loading?Container():Container(
                        child: SingleChildScrollView(
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Personal Details", style: secondaryTextStyle(size: 18)),
                                    // IconButton(onPressed: () {}, icon: Icon(Icons.add_circle_outline, color: js_primaryColor)),
                                  ],
                                ),
                                Divider(height: 0, color: gray.withOpacity(0.2)),
                                8.height,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(user[0].name, style: boldTextStyle()),
                                  ],
                                ),
                                24.height,
                                Text(user[0].location, style: boldTextStyle(size: 22)),
                                8.height,
                                Row(
                                  children: [
                                    Icon(Icons.email, color: Theme.of(context).iconTheme.color),
                                    8.width,
                                    Text(added?user[0].email:'*** ** (Add To See)', style: primaryTextStyle()),
                                  ],
                                ),
                                8.height,
                                Row(
                                  children: [
                                    Icon(Icons.call, color: Theme.of(context).iconTheme.color),
                                    8.width,
                                    Text(added?user[0].phone:'*** ** (Add To See)', style: primaryTextStyle(color: js_primaryColor, decoration: TextDecoration.underline)),
                                  ],
                                ),

                                24.height,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Work Experience", style: secondaryTextStyle(size: 18)),

                                  ],
                                ),
                                Divider(height: 0, color: gray.withOpacity(0.2)),
                                8.height,
                                for(int i = 0;i < work.length;i++)
                                  Column(
                                      crossAxisAlignment:  CrossAxisAlignment.start,
                                      children:[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(work[i].title, style: boldTextStyle()),
                                            Row(
                                              children: [
                                                IconButton(onPressed: () {kl(context,work[i]);}, icon: Icon(Icons.remove_red_eye, color: js_primaryColor)),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Text(work[i].city, style: primaryTextStyle()),
                                        8.height,
                                        Text('${work[i].work_from} to ${work[i].work_to}', style: secondaryTextStyle()),
                                        8.height,
                                        Text(work[i].work_type, style: primaryTextStyle()),
                                        24.height,
                                      ]),
                                24.height,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Education", style: secondaryTextStyle(size: 18)),
                                  ],
                                ),
                                Divider(height: 0, color: gray.withOpacity(0.2)),
                                8.height,
                                for(int i = 0;i < edu.length;i++)
                                  Column(
                                      crossAxisAlignment:  CrossAxisAlignment.start,
                                      children:[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(edu[i].title, style: boldTextStyle()),
                                            Row(
                                              children: [
                                                IconButton(onPressed: () {ed(context,edu[i]);}, icon: Icon(Icons.remove_red_eye, color: js_primaryColor)),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Text(edu[i].city, style: primaryTextStyle()),
                                        8.height,
                                        Text('${edu[i].learn_from} to ${edu[i].learn_to}', style: secondaryTextStyle()),
                                        8.height,
                                        Text(edu[i].school_type, style: primaryTextStyle()),
                                        24.height,
                                      ]),
                                24.height,
                              ],
                            ),
                          ),
                        )
                    ),
                    loading?Container():Container(
                        child: SingleChildScrollView(
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Description", style: secondaryTextStyle(size: 18))
                                  ],
                                ),
                                Divider(height: 0, color: gray.withOpacity(0.2)),
                                HtmlWidget(
                                  // the first parameter (`html`) is required
                                  user[0].description,

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
                                300.height,

                              ],
                            ),
                          ),
                        )
                    ),
                  ],
                ).expand(),
              ],
            );
          }))
    );
  }
}
