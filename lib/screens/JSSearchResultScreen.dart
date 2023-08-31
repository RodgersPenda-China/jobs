import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:job_search/components/JSFilteredResultsComponent.dart';
import 'package:job_search/screens/JSFilteredScreen.dart';
import 'package:job_search/utils/JSColors.dart';
import 'package:job_search/utils/JSWidget.dart';
import 'package:job_search/main.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../components/JSDrawerScreen.dart';
import '../components/JSJobDetailComponent.dart';
import '../components/JSRemoveJobComponent.dart';
import '../controller/home.dart';
import 'package:badges/badges.dart' as badges;
import '../model/JSPopularCompanyModel.dart';
import '../utils/JSConstant.dart';
import '../utils/JSDataGenerator.dart';
import '../widgets/JSFilteredResultWidget.dart';
import 'JSCompanyProfileScreens.dart';
import 'JSHomeScreen.dart';

class JSSearchResultScreen extends StatefulWidget {
  final String? jobTitle;
  final String? city;

  JSSearchResultScreen({this.jobTitle, this.city});

  @override
  _JSSearchResultScreenState createState() => _JSSearchResultScreenState();
}

class _JSSearchResultScreenState extends State<JSSearchResultScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  String daysValue = 'Date Posted';

  var daysItems = ['Date Posted', 'Last 1 days', 'Last 2 days', 'Last 3 days', 'Last 4 days'];

  String jobCategoryValue = 'Job Type';

  var jobCategoryItems = ['Job Type', 'Full-Time', 'Part-Time', 'Contract', 'Internship'];

  String salaryValue = 'Remote/Online'; bool reached_bottom = false;
  List<JSPopularCompanyModel> filteredResultsList = getFilteredResultsData();
  bool loading = true;
  var salaryItems = ['Remote/Online', 'Remote', 'Online'];
  var jobs = [];
  late ScrollController _controller;
  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
    make_https();
  }
  String message = ''; String search = ''; int called = 0;
  _scrollListener() async {
    print(_controller.position);
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      print("reach the bottom");
      setState(() {
        message = "reach the bottom"; reached_bottom = true; called = 1;
      });
      int limit = Get.find<HomeController>().limit;
      int offset = Get.find<HomeController>().offset;
      print('offset: ${offset}');
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String url = '';
      if(token != null && token != '') {
        url = "http://api.ioevisa.net/api/job/index.php?get_jobs=1&token=${token}&limit=${limit}&offset=${offset}";
      } else {
        url = "http://api.ioevisa.net/api/job/index.php?get_jobs=1&limit=${limit}&offset=${offset}";
      }
      if(Get.find<HomeController>().filter_on = true)
      { String category='';
        if(Get.find<HomeController>().filter_category != ''){
          category = Get.find<HomeController>().filter_category;
        }
        String city=fg['city']!,type=fg['type']!,
            remote=fg['remote']!;
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('token');
        if(token != null && token != '') {
          url = "http://api.ioevisa.net/api/job/index.php?get_jobs=1&filter=1&city=${city}"
              "&category=${category}&type=${type}&remote=${remote}&token=${token}&limit=${limit}&offset=${offset}";
        } else {
          url = "http://api.ioevisa.net/api/job/index.php?get_jobs=1&filter=1&city=${city}"
              "&category=${category}&type=${type}&remote=${remote}&limit=${limit}&offset=${offset}";
        }
      }
      if(search != ''){
        url = "http://api.ioevisa.net/api/job/index.php?get_jobs=1&token=${token}&search=${search}&limit=${limit}&offset=${offset}";
      }
      print(url);
      final response = await http.get(Uri.parse(url));
      setState(() {
        reached_bottom = false;
      });

      var kv = jsonDecode(response.body);
      for(int i = 0; i < kv.length;i++){

        setState(() {
          jobs.add(kv[i]);
          Get.find<HomeController>().filter_array.add(kv[i]);
          Get.find<HomeController>().offset = offset+25;
        });
      }
      print(jobs.length);
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        message = "reach the top";
      });
    }
  }
  int role = 0;

  make_https() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String url = '';

    if(token != null && token != '') {
      url = "http://api.ioevisa.net/api/job/index.php?get_jobs=1&token=${token}&limit=25&offset=0";
    } else {
      url = "http://api.ioevisa.net/api/job/index.php?get_jobs=1&limit=25&offset=0";
    }
    setState(() {
      role = prefs.getInt('role')!;
      loading = true;
    });
    print(url);
    final response = await http.get(Uri.parse(url));
    setState(() {
      loading = false;
      jobs = json.decode(response.body);
      Get.find<HomeController>().offset = 25;
    });
    print('object');
    // var jobs = ;
  }
  var fg = {'city':'','category':'','type':'','remote':''};
  filter(String but,String why) async {
    setState(() {
      fg[but] = why;loading = true;
    });
    String category='';
    if(Get.find<HomeController>().filter_category != ''){
      category = Get.find<HomeController>().filter_category;
    }
    setState(() {
      Get.find<HomeController>().filter_on = true;
      Get.find<HomeController>().limit = 25;
      Get.find<HomeController>().offset = 0;

    });
  String city=fg['city']!,type=fg['type']!,
      remote=fg['remote']!;
    String url = '';
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if(token != null && token != '') {
      url = "http://api.ioevisa.net/api/job/index.php?get_jobs=1&filter=1&city=${city}"
          "&category=${category}&type=${type}&remote=${remote}&token=${token}&limit=25&offset=0";
    } else {
      url = "http://api.ioevisa.net/api/job/index.php?get_jobs=1&filter=1&city=${city}&limit=2&offset=0"
          "&category=${category}&type=${type}&remote=${remote}&limit=25&offset=0";
    }
    print(url);
    final response = await http.get(Uri.parse(url));
     Get.find<HomeController>().loading_from = 0;
    setState(() {
      loading = false;
      jobs = json.decode(response.body);
      Get.find<HomeController>().offset = 25;
    });
  }
  bool apply_loading = false; var cv_body = []; bool job_apply = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: JSDrawerScreen(),
      appBar: jsAppBar(context, notifications: true, message: true, bottomSheet: true, backWidget: false, homeAction: false, callBack: () {

        setState(() {});
        scaffoldKey.currentState!.openDrawer();
      }),
      body:GetBuilder<HomeController>(builder: (authController){
      return SingleChildScrollView(
          controller: _controller,
          child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [

            ],
          ),
          Container(
            height: textFieldHeight,
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 24),
            decoration: boxDecoration(radius: 8, color: appStore.isDarkModeOn ? scaffoldDarkColor : white),
            child: AppTextField(
              onChanged: (k){search = k;},
              onFieldSubmitted: (v) async {
                final SharedPreferences prefs = await SharedPreferences.getInstance();
                String? token = prefs.getString('token');
                String url = '';

                if(token != null && token != '') {
                  url = "http://api.ioevisa.net/api/job/index.php?get_jobs=1&token=${token}&search=${v}";
                } else {
                  url = "http://api.ioevisa.net/api/job/index.php?get_jobs=1&search=${v}";
                }
                setState(() {
                  role = prefs.getInt('role')!;
                  loading = true;
                });
                print(url);
                final response = await http.get(Uri.parse(url));
                setState(() {
                  loading = false;
                  jobs = json.decode(response.body);
                });
                print('object');
              },
              textFieldType: TextFieldType.NAME,
              decoration: jsInputDecoration(
                hintText: "Search for jobs title, keyword or company",
                showPreFixIcon: true,
                prefixIcon: Icon(Icons.search,color: Theme.of(context).iconTheme.color,size: 20),
              ),
            ),
          ),
          Container(height: 10, color: appStore.isDarkModeOn ? scaffoldDarkColor : js_backGroundColor),
          8.height,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                filteredWidget(widget: Icon(Icons.filter_list,color:  Get.find<HomeController>().filter_category == ''?Colors.pink:Colors.blue, size: 18)).cornerRadiusWithClipRRect(8).onTap(() {
                  JSFilteredScreen(filter: fg,).launch(context);
                }),
                8.width,
                // Container(
                //   decoration: boxDecorationWithRoundedCorners(
                //     borderRadius: BorderRadius.circular(8),
                //     backgroundColor: appStore.isDarkModeOn ? scaffoldDarkColor : js_backGroundColor,
                //   ),
                //   height: 35,
                //   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                //   child: DropdownButton(
                //     isExpanded: false,
                //     underline: Container(color: Colors.transparent),
                //     value: daysValue,
                //     icon: Icon(Icons.arrow_drop_down),
                //     items: daysItems.map((String daysItems) {
                //       return DropdownMenuItem(
                //         value: daysItems,
                //         child: Text(daysItems, style: primaryTextStyle(size: 14)),
                //       );
                //     }).toList(),
                //     onChanged: (String? newValue) {
                //       setState(() {
                //         daysValue = newValue!;
                //       });
                //     },
                //   ),
                // ),
                // 8.width,
                Container(
                  decoration: boxDecorationWithRoundedCorners(
                    borderRadius: BorderRadius.circular(8),
                    backgroundColor: appStore.isDarkModeOn ? scaffoldDarkColor : js_backGroundColor,
                  ),
                  height: 35,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  child: DropdownButton(
                    isExpanded: false,
                    underline: Container(color: Colors.transparent),
                    value: jobCategoryValue,
                    icon: Icon(Icons.arrow_drop_down),
                    items: jobCategoryItems.map((String jobCategoryItems) {
                      return DropdownMenuItem(
                        value: jobCategoryItems,
                        child: Text(jobCategoryItems, style: primaryTextStyle(size: 14)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        jobCategoryValue = newValue!;
                      });
                      filter('type', newValue!);
                    },
                  ),
                ),
                8.width,
                Container(
                  decoration: boxDecorationWithRoundedCorners(
                    borderRadius: BorderRadius.circular(8),
                    backgroundColor: appStore.isDarkModeOn ? scaffoldDarkColor : js_backGroundColor,
                  ),
                  height: 35,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  child: DropdownButton(
                    isExpanded: false,
                    underline: Container(color: Colors.transparent),
                    value: salaryValue,
                    icon: Icon(Icons.arrow_drop_down),
                    items: salaryItems.map((String salaryItems) {
                      return DropdownMenuItem(
                        value: salaryItems,
                        child: Text(salaryItems, style: primaryTextStyle(size: 14)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        salaryValue = newValue!;
                      });
                      filter('remote', newValue!);
                    },
                  ),
                ),
                8.width,
                //filteredWidget(widget: Text("Applications", style: primaryTextStyle(size: 14,color: Colors.blue))),
              ],
            ),
          ),
          8.height,
          // Text(
          //   "${widget.jobTitle.validate()} jobs in ${widget.city.validate()}, Greater ${widget.city.validate()}",
          //   style: primaryTextStyle(),
          //   textAlign: TextAlign.start,
          // ).paddingOnly(left: 16),
          // 4.height,
          // Row(
          //   children: [
          //     Text("page 1 of 545 jobs ${Get.find<HomeController>().loading_from}", style: secondaryTextStyle()),
          //     4.width,
          //     Icon(Icons.help, color: gray.withOpacity(0.5), size: 18),
          //   ],
          // ).paddingOnly(left: 16),
          16.height,
         loading|| Get.find<HomeController>().filter_loading?Shimmer.fromColors(child: Container(

            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Loading Jobs, Please Wait", style: primaryTextStyle(size: 14)),
                    Icon(
                      1 == 1 ? Icons.favorite : Icons.favorite_border,
                      size: 20,
                      color: 1 == 1
                          ? js_primaryColor
                          : appStore.isDarkModeOn
                          ? white
                          : black,
                    ).onTap(() {
                     // filteredResultsList[i].selectSkill = !filteredResultsList[i].selectSkill.validate();
                      setState(() {});
                    }),
                  ],
                ),
                8.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Marketing Manager', style: boldTextStyle()),
                    8.width,
                    Icon(Icons.block, size: 20).onTap(() {
                      //filteredResultsList[i].isBlocked = !filteredResultsList[i].isBlocked.validate();
                      setState(() {});
                    }),
                  ],
                ),
                4.height,
                Text('Ndola', style: primaryTextStyle()),
                4.height,
                Text("Remote: Yes", style: primaryTextStyle()),
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
                        'Nk',
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
                    Text("2 Years Working Experience", style: secondaryTextStyle()),
                  ],
                ),
                8.height,
                Row(
                  children: [
                    Icon(Icons.school, size: 18, color: Colors.red),
                    4.width,
                    Text("Bachelor Degree", style: secondaryTextStyle()),
                  ],
                ),
                8.height,
                Row(
                  children: [
                    Icon(Icons.watch_later_outlined, size: 18, color: gray.withOpacity(0.8)),
                    4.width,
                    Text("Full Time", style: secondaryTextStyle()),
                  ],
                ),
                16.height,
                Text('Just Now', style: secondaryTextStyle()),
              ],
            ),
          ),

              baseColor: Colors.red, highlightColor: Colors.blue):
          jobs.length == 0?Center(child:Text("No Jobs Found")):
          Get.find<HomeController>().loading_from == 0?
          SingleChildScrollView(
            child: Column(
              children: [
                for(int i = 0; i < jobs.length;i++)
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
                            Text("${jobs[i]['applied'] == 'yes'?'Applied!':'New'}", style: primaryTextStyle(size: 14,color: Colors.red)),

                            Icon(
                              1 == 0 ? Icons.favorite : Icons.favorite_border,
                              size: 20,
                              color: 1 == 0
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
                            Text(jobs[i]['name'], style: boldTextStyle()),
                            8.width,
                            Icon(Icons.block, size: 20).onTap(() {
                              //filteredResultsList[i].isBlocked = !filteredResultsList[i].isBlocked.validate();
                              setState(() {});
                            }),
                          ],
                        ),
                        4.height,
                        Text(jobs[i]['city'], style: primaryTextStyle()),
                        4.height,
                        Text("Remote: ${jobs[i]['remote']}", style: primaryTextStyle()),
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
                                'ZK'+jobs[i]['salary']+'/Month',
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
                            Text("${jobs[i]['experience']} Years Working Experience", style: secondaryTextStyle()),
                          ],
                        ),
                        8.height,
                        Row(
                          children: [
                            Icon(Icons.school, size: 18, color: Colors.red),
                            4.width,
                            Text("${jobs[i]['education']}", style: secondaryTextStyle()),
                          ],
                        ),
                        8.height,
                        Row(
                          children: [
                            Icon(Icons.watch_later_outlined, size: 18, color: gray.withOpacity(0.8)),
                            4.width,
                            Text("${jobs[i]['kind']}", style: secondaryTextStyle()),
                          ],
                        ),
                        16.height,
                        Text(' ${jobs[i]['posted_time']}', style: secondaryTextStyle()),
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
                              Text(jobs[i]['name'], style: boldTextStyle(size: 22)),
                              8.height,
                              Text(jobs[i]['short_name'], style: primaryTextStyle()),
                              8.height,
                              Text('${jobs[i]['city']} . ${jobs[i]['remote'] == 'Yes'?'Remote':'Online'}', style: primaryTextStyle()),
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
                                          Text("${jobs[i]['experience']} Years Working Experience", style: secondaryTextStyle()),
                                        ],
                                      ),
                                      8.height,
                                      Row(
                                        children: [
                                          Icon(Icons.school, size: 18, color: Colors.red),
                                          4.width,
                                          Text(jobs[i]['education'], style: secondaryTextStyle()),
                                        ],
                                      ),
                                      8.height,
                                      Row(
                                        children: [
                                          Icon(Icons.watch_later_outlined, size: 18, color: gray.withOpacity(0.8)),
                                          4.width,
                                          Text(jobs[i]['kind'], style: secondaryTextStyle()),
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
                                            imageUrl: jobs[i]['image'],
                                            placeholder: (context, url) => CircularProgressIndicator(),
                                            errorWidget: (context, url, error) => Icon(Icons.error),
                                          )
                                      ),
                                      subtitle: GestureDetector(
                                        onTap: (){
                                          JSCompanyProfileScreens(id: jobs[i]['user_id'],employer: 0,).launch(context);
                                        },
                                        child:Text("Other ${jobs[i]['jobs']} Jobs"),
                                      ),
                                      title:GestureDetector(
                                        onTap: (){
                                          JSCompanyProfileScreens(id: jobs[i]['user_id'],employer: 0).launch(context);

                                        },
                                        child: Text(
                                        jobs[i]['short_name'],
                                        style: TextStyle(fontSize: 20),
                                      )),

                                      trailing: GestureDetector(
                                        onTap: (){
                                          JSCompanyProfileScreens(id: jobs[i]['user_id'],employer: 0).launch(context);

                                        },
                                        child:
                                        GestureDetector(
                                            onTap: (){
                                              launchUrl(Uri.parse('https://www.google.com/maps/dir/?api=1&destination=${jobs[i]['location']}&destination_place_id=${jobs[i]['place_id']}'
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
                              Text('ZK${jobs[i]['salary']}/Month', style: primaryTextStyle()),
                              16.height,
                              Text("Job type", style: boldTextStyle()),
                              4.height,
                              jsGetPrimaryTitle(jobs[i]['kind']),
                              4.height,
                              jsGetPrimaryTitle(jobs[i]['category']),
                              4.height,
                              jsGetPrimaryTitle(jobs[i]['remote'] == 'Yes'?'Remote':'Online'),
                              4.height,
                              Divider(),
                              16.height,
                              Text("Full Job Description", style: boldTextStyle(size: 20)),
                              16.height,
                              HtmlWidget(
                                // the first parameter (`html`) is required
                                jobs[i]['description'],

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
                            role == 0?  Positioned(
                                left: 0,
                                right: 0,
                                bottom: 8,
                                child: AppButton(
                                  onTap: () async {
                                    //applying loading
                                    if(jobs[i]['applied'] == 'yes'){return;}
                                    final SharedPreferences prefs = await SharedPreferences.getInstance();
                                    String? token = prefs.getString('token');
                                    String url = "http://api.ioevisa.net/api/job/index.php?get_cvs=1&token=${token}";
                                    setState(() {
                                      apply_loading = true;
                                    });
                                    EasyLoading.show(status: 'loading...');

                                    print(url);print(apply_loading);
                                    final response = await http.get(Uri.parse(url));
                                    Get.find<HomeController>().user_loading = true;
                                    setState(() {
                                      apply_loading = false;
                                      cv_body = jsonDecode(response.body);
                                    });
                                    EasyLoading.dismiss();
                                    showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                        ),
                                        builder: (context) {
                                          return // Column(
                                            //children: [
                                            Card (
                                              margin: EdgeInsets.all(10),
                                              shadowColor: Colors.blueGrey,
                                              elevation: 10,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Text('Select Cv',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                                                  for(int index = 0; index < cv_body.length;index++)
                                                    ListTile(
                                                      leading:
                                                      cv_body[index]['name'].split(".").last == 'png'|| cv_body[index]['name'].split(".").last == 'jpg'
                                                          || cv_body[index]['name'].split(".").last == 'jpeg'?
                                                      Icon (
                                                          Icons.image,
                                                          color: Colors.greenAccent,
                                                          size: 45
                                                      ):cv_body[index]['name'].split(".").last == 'pdf'?
                                                      Icon (
                                                          Icons.picture_as_pdf,
                                                          color: Colors.red,
                                                          size: 45
                                                      ):
                                                      cv_body[index]['name'].split(".").last == 'docx'?
                                                      Image.asset('images/jobSearch/docx.png'):Icon (
                                                          Icons.file_present,
                                                          color: Colors.blueGrey,
                                                          size: 45
                                                      ),
                                                      title: Text(
                                                        cv_body[index]['name'],
                                                        style: TextStyle(fontSize: 20),
                                                      ),
                                                      trailing:
                                                      GestureDetector(
                                                        onTap: () async {
                                                          EasyLoading.show(status: 'Applying...');
                                                          //apply
                                                          print(Get.find<HomeController>().filter_array.toString());
                                                          String cv_id = cv_body[index]['id']; String job_id =  jobs[i]['id'];
                                                          String url = "http://api.ioevisa.net/api/job/index.php?apply=1&token=${token}&cv_id=${cv_id}&job=${job_id}";
                                                          setState(() {
                                                            job_apply = true;
                                                          });
                                                          print(url); print(job_apply);
                                                          final response = await http.get(Uri.parse(url));
                                                          setState(() {
                                                            job_apply = false;
                                                            //cv_body = jsonDecode(response.body);
                                                          });
                                                          setState(() {
                                                            jobs[i]['applied'] = 'yes';
                                                          });
                                                          EasyLoading.dismiss();
                                                          Navigator.pop(context);
                                                          Navigator.pop(context);
                                                        },
                                                        child:Icon (
                                                            Icons.send,
                                                            color: Colors.blue,
                                                            size: 23
                                                        ),
                                                      ),

                                                    ),
                                                ],
                                              ),
                                            );
                                          // ],
                                          //);
                                        });
                                    //JSHomeScreen().launch(context);
                                  },
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.all(16),
                                  color: jobs[i]['applied'] == 'no'?js_primaryColor:Colors.red,
                                  child: jobs[i]['applied'] == 'no'?
                                  Text("Apply Now", style: boldTextStyle(color: white)):
                                  Text("Applied", style: boldTextStyle(color: white)),

                                ),
                              ):SizedBox()
                            ],
                          ),
                        );
                      },
                    );
                  })
              ],
            ),
          ):
          SingleChildScrollView(
            child: Column(
              children: [
                for(int i = 0; i < Get.find<HomeController>().filter_array.length;i++)
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
                            Text("${Get.find<HomeController>().filter_array[i]['applied'] == 'yes'?'Applied!':'New'} ${Get.find<HomeController>().filter_array[i]['applied']} ${i}", style: primaryTextStyle(size: 14,color: Colors.red)),
                            Icon(
                              1 == 0 ? Icons.favorite : Icons.favorite_border,
                              size: 20,
                              color: js_primaryColor,
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
                            Text( Get.find<HomeController>().filter_array[i]['name'], style: boldTextStyle()),
                            8.width,
                            Icon(Icons.block, size: 20).onTap(() {
                              //filteredResultsList[i].isBlocked = !filteredResultsList[i].isBlocked.validate();
                              setState(() {});
                            }),
                          ],
                        ),
                        4.height,
                        Text( Get.find<HomeController>().filter_array[i]['city'], style: primaryTextStyle()),
                        4.height,
                        Text("Remote: ${ Get.find<HomeController>().filter_array[i]['remote']}", style: primaryTextStyle()),
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
                                'ZK'+ Get.find<HomeController>().filter_array[i]['salary']+'/Month',
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
                            Text("${ Get.find<HomeController>().filter_array[i]['experience']} Years Working Experience", style: secondaryTextStyle()),
                          ],
                        ),
                        8.height,
                        Row(
                          children: [
                            Icon(Icons.school, size: 18, color: Colors.red),
                            4.width,
                            Text("${ Get.find<HomeController>().filter_array[i]['education']}", style: secondaryTextStyle()),
                          ],
                        ),
                        8.height,
                        Row(
                          children: [
                            Icon(Icons.watch_later_outlined, size: 18, color: gray.withOpacity(0.8)),
                            4.width,
                            Text("${ Get.find<HomeController>().filter_array[i]['kind']}", style: secondaryTextStyle()),
                          ],
                        ),
                        16.height,
                        Text(' ${Get.find<HomeController>().filter_array[i]['posted_time']}', style: secondaryTextStyle()),
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
                                      Text( Get.find<HomeController>().filter_array[i]['name'], style: boldTextStyle(size: 22)),
                                      8.height,
                                      Text( Get.find<HomeController>().filter_array[i]['short_name'], style: primaryTextStyle()),
                                      8.height,
                                      Text('${ Get.find<HomeController>().filter_array[i]['city']} . ${jobs[i]['remote'] == 'Yes'?'Remote':'Online'}', style: primaryTextStyle()),
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
                                                  Text("${ Get.find<HomeController>().filter_array[i]['experience']} Years Working Experience", style: secondaryTextStyle()),
                                                ],
                                              ),
                                              8.height,
                                              Row(
                                                children: [
                                                  Icon(Icons.school, size: 18, color: Colors.red),
                                                  4.width,
                                                  Text( Get.find<HomeController>().filter_array[i]['education'], style: secondaryTextStyle()),
                                                ],
                                              ),
                                              8.height,
                                              Row(
                                                children: [
                                                  Icon(Icons.watch_later_outlined, size: 18, color: gray.withOpacity(0.8)),
                                                  4.width,
                                                  Text( Get.find<HomeController>().filter_array[i]['kind'], style: secondaryTextStyle()),
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
                                                    imageUrl:  Get.find<HomeController>().filter_array[i]['image'],
                                                    placeholder: (context, url) => CircularProgressIndicator(),
                                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                                  )
                                              ),
                                              subtitle: GestureDetector(
                                                onTap: (){
                                                  JSCompanyProfileScreens(id:  Get.find<HomeController>().filter_array[i]['user_id'],employer: 0).launch(context);
                                                },
                                                child:Text("Other ${ Get.find<HomeController>().filter_array[i]['jobs']} Jobs"),
                                              ),
                                              title:GestureDetector(
                                                  onTap: (){
                                                    JSCompanyProfileScreens(id:  Get.find<HomeController>().filter_array[i]['user_id'],employer: 0).launch(context);

                                                  },
                                                  child: Text(
                                                    Get.find<HomeController>().filter_array[i]['short_name'],
                                                    style: TextStyle(fontSize: 20),
                                                  )),

                                              trailing: GestureDetector(
                                                  onTap: (){
                                                    JSCompanyProfileScreens(id: jobs[i]['user_id'],employer: 0).launch(context);

                                                  },
                                                  child:
                                                  GestureDetector(
                                                      onTap: (){
                                                        launchUrl(Uri.parse('https://www.google.com/maps/dir/?api=1&destination=${jobs[i]['location']}&destination_place_id=${jobs[i]['place_id']}'
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
                                      Text('ZK${ Get.find<HomeController>().filter_array[i]['salary']}/Month', style: primaryTextStyle()),
                                      16.height,
                                      Text("Job type", style: boldTextStyle()),
                                      4.height,
                                      jsGetPrimaryTitle( Get.find<HomeController>().filter_array[i]['kind']),
                                      4.height,
                                      jsGetPrimaryTitle( Get.find<HomeController>().filter_array[i]['category']),
                                      4.height,
                                      jsGetPrimaryTitle( Get.find<HomeController>().filter_array[i]['remote'] == 'Yes'?'Remote':'Online'),
                                      4.height,
                                      Divider(),
                                      16.height,
                                      Text("Full Job Description", style: boldTextStyle(size: 20)),
                                      16.height,
                                      HtmlWidget(
                                        // the first parameter (`html`) is required
                                        Get.find<HomeController>().filter_array[i]['description'],

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
                                    onTap: () async {
                                      //applying loading
                                      if(Get.find<HomeController>().filter_array[i]['applied'] == 'yes'){return;}
                                      final SharedPreferences prefs = await SharedPreferences.getInstance();
                                      String? token = prefs.getString('token');
                                      String url = "http://api.ioevisa.net/api/job/index.php?get_cvs=1&token=${token}";
                                      setState(() {
                                        apply_loading = true;
                                      });
                                      EasyLoading.show(status: 'loading...');

                                      print(url);print(apply_loading);
                                      final response = await http.get(Uri.parse(url));
                                      Get.find<HomeController>().user_loading = true;
                                      setState(() {
                                        apply_loading = false;
                                        cv_body = jsonDecode(response.body);
                                      });
                                      EasyLoading.dismiss();
                                      showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                      ),
                                      builder: (context) {
                                      return // Column(
                                        //children: [
                                          Card (
                                            margin: EdgeInsets.all(10),
                                            shadowColor: Colors.blueGrey,
                                            elevation: 10,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Text('Select Cv',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                                                for(int index = 0; index < cv_body.length;index++)
                                                  ListTile(
                                                    leading:
                                                    cv_body[index]['name'].split(".").last == 'png'|| cv_body[index]['name'].split(".").last == 'jpg'
                                                        || cv_body[index]['name'].split(".").last == 'jpeg'?
                                                    Icon (
                                                        Icons.image,
                                                        color: Colors.greenAccent,
                                                        size: 45
                                                    ):cv_body[index]['name'].split(".").last == 'pdf'?
                                                    Icon (
                                                        Icons.picture_as_pdf,
                                                        color: Colors.red,
                                                        size: 45
                                                    ):
                                                    cv_body[index]['name'].split(".").last == 'docx'?
                                                    Image.asset('images/jobSearch/docx.png'):Icon (
                                                        Icons.file_present,
                                                        color: Colors.blueGrey,
                                                        size: 45
                                                    ),
                                                    title: Text(
                                                      cv_body[index]['name'],
                                                      style: TextStyle(fontSize: 20),
                                                    ),
                                                    trailing:
                                                        GestureDetector(
                                                          onTap: () async {
                                                            EasyLoading.show(status: 'Applying...');
                                                            //apply
                                                            String cv_id = cv_body[index]['id']; String job_id =  Get.find<HomeController>().filter_array[i]['id'];
                                                            String url = "http://api.ioevisa.net/api/job/index.php?apply=1&token=${token}&cv_id=${cv_id}&job=${job_id}";
                                                            setState(() {
                                                              job_apply = true;
                                                            });
                                                            print(url); print(job_apply);
                                                            final response = await http.get(Uri.parse(url));
                                                            setState(() {
                                                              job_apply = false;
                                                              //cv_body = jsonDecode(response.body);
                                                            });
                                                            setState(() {
                                                              Get.find<HomeController>().filter_array[i]['applied'] = 'yes';
                                                            });
                                                            EasyLoading.dismiss();
                                                            Navigator.pop(context);
                                                            Navigator.pop(context);
                                                          },
                                                          child:Icon (
                                                              Icons.send,
                                                              color: Colors.blue,
                                                              size: 23
                                                          ),
                                                        ),

                                                  ),
                                              ],
                                            ),
                                          );
                                       // ],
                                      //);
                                      });
                                      //JSHomeScreen().launch(context);
                                    },
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.all(16),
                                    color: Get.find<HomeController>().filter_array[i]['applied'] == 'no'?js_primaryColor:Colors.red,
                                    child: Get.find<HomeController>().filter_array[i]['applied'] == 'no'?
                                    Text("Apply Now", style: boldTextStyle(color: white)):
                                    Text("Applied", style: boldTextStyle(color: white)),

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
          reached_bottom?Shimmer.fromColors(child: Container(

            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Loading Jobs, Please Wait", style: primaryTextStyle(size: 14)),
                    Icon(
                      1 == 1 ? Icons.favorite : Icons.favorite_border,
                      size: 20,
                      color: 1 == 1
                          ? js_primaryColor
                          : appStore.isDarkModeOn
                          ? white
                          : black,
                    ).onTap(() {
                      // filteredResultsList[i].selectSkill = !filteredResultsList[i].selectSkill.validate();
                      setState(() {});
                    }),
                  ],
                ),
                8.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Marketing Manager', style: boldTextStyle()),
                    8.width,
                    Icon(Icons.block, size: 20).onTap(() {
                      //filteredResultsList[i].isBlocked = !filteredResultsList[i].isBlocked.validate();
                      setState(() {});
                    }),
                  ],
                ),
                4.height,
                Text('Ndola', style: primaryTextStyle()),
                4.height,
                Text("Remote: Yes", style: primaryTextStyle()),
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
                        'Nk',
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
                    Text("2 Years Working Experience", style: secondaryTextStyle()),
                  ],
                ),
                8.height,
                Row(
                  children: [
                    Icon(Icons.school, size: 18, color: Colors.red),
                    4.width,
                    Text("Bachelor Degree", style: secondaryTextStyle()),
                  ],
                ),
                8.height,
                Row(
                  children: [
                    Icon(Icons.watch_later_outlined, size: 18, color: gray.withOpacity(0.8)),
                    4.width,
                    Text("Full Time", style: secondaryTextStyle()),
                  ],
                ),
                16.height,
                Text('Just Now', style: secondaryTextStyle()),
              ],
            ),
          ),

              baseColor: Colors.red, highlightColor: Colors.blue):
         called == 0? SizedBox():
          Center(child: Text('You Have Reached The End'),)
        ],
      ));})
    );

  }
}
