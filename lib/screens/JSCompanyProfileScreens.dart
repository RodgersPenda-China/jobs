import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
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
import 'package:url_launcher/url_launcher.dart';

import '../controller/home.dart';
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
  bool loading = true;int role = 0;
  @override
  void initState() {
    super.initState();
    make_https();
  }
  var jobs = {}; bool image_loading = false; List<String> listOfUrls= [];

  make_https() async {
    String url = '';
    if(widget.employer == 0) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
       url = "http://api.ioevisa.net/api/job/index.php?get_company=1&id=${widget
          .id}&token=${token}";
    } else {
       SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      url = "http://api.ioevisa.net/api/job/index.php?get_company=1&token=${token}";
      setState(() { role = prefs.getInt('role')!;});
    }
     SharedPreferences pref = await SharedPreferences.getInstance();
    print(url);
    setState(() {
      loading = true; image_loading = true;role = pref.getInt('role')!;
    });
    final response = await http.get(Uri.parse(url));
    setState(() {
      loading = false;
      jobs = json.decode(response.body);
    });

    List<String> images = [];
    for(int i = 0; i < jobs['user'][0]['photos'].length; i++){
      images.add(jobs['user'][0]['photos'][i]);
    }
    setState(() {
      listOfUrls = images;
      image_loading = false;
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
  bool apply_loading = false; var cv_body = []; bool job_apply = false;

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
                      commonCachedNetworkImage(jobs['user'][0]['image'], height: 50, width: 50, fit: BoxFit.contain),

                      // jobs['user'][0]['image'] != ''?CachedNetworkImage(
                      //   imageUrl: jobs['user'][0]['image'],
                      //   placeholder: (context, url) => CircularProgressIndicator(),
                      //   errorWidget: (context, url, error) => Icon(Icons.error),
                      // ):
                      // Text('Logo', style: boldTextStyle(size: 22)),
                      16.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child:                           Text(jobs['user'][0]['long_name'], style: boldTextStyle(color: white)),
                            width: 200,
                          ),
                          8.height,
                          GestureDetector(
                            onTap: (){
                              launchUrl(Uri.parse('https://www.google.com/maps/dir/?api=1&destination=${jobs['user'][0]['location']}&destination_place_id=${jobs['user'][0]['place_id']}'
                              ),mode: LaunchMode.externalNonBrowserApplication,);
                            },
                            child:
                          Row(
                            children: [
                                  Icon(Icons.location_on_outlined, color: white, size: 16),
                              Text(jobs['user'][0]['location'],style: boldTextStyle(color: white))


                          ])),
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
                                Text("${jobs['job'][i]['applied'] == 'yes'?'Applied!':'New'}", style: primaryTextStyle(size: 14,color: Colors.red)),

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
                                    role == 0? Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 8,
                                      child: AppButton(
                                        onTap: () async {
                                          //applying loading
                                          if(jobs['job'][i]['applied'] == 'yes'){return;}
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
                                                                String cv_id = cv_body[index]['id']; String job_id =  jobs['job'][i]['id'];
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
                                                                  jobs['job'][i]['applied'] = 'yes';
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
                                        color: jobs['job'][i]['applied'] == 'no'?js_primaryColor:Colors.red,
                                        child: jobs['job'][i]['applied'] == 'no'?
                                        Text("Apply Now", style: boldTextStyle(color: white)):
                                        Text("Applied", style: boldTextStyle(color: white)),

                                      ),
                                    ):SizedBox(),
                                  ],
                                ),
                              );
                          },
                        );
                      })
                  ],
                ),
              ),
              image_loading?CircularProgressIndicator(color: Colors.blue,):
              jobs['user'][0]['photos'].length == 0? Center(child: Text('No Image'),):Container(
                  child:
                  Column(
                    children: [
                      GalleryImage(
                        // key: _key,
                        imageUrls: listOfUrls,
                        numOfShowImages: 4,
                        titleGallery: '${jobs['user'][0]['short_name']}',
                      )
                    ],
                  )

              )
            ]).expand(),
          ],
        ),
      ),
    );
  }
}
