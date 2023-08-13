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
import 'package:job_search/screens/post_job.dart';
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
import 'package:galleryimage/galleryimage.dart';
import '../components/JSReviewAndSaVeComponent.dart';
import '../controller/home.dart';
import '../model/user.dart';
import 'JSCompleteProfileOneScreen.dart';
import 'education.dart';
import 'package:http/http.dart' as http;
class EmployeeScreen extends StatefulWidget {
  //String id;
  //EmployeeScreen({Key? key,required this.id}) : super(key: key);

  @override
  _JSProfileScreenState createState() => _JSProfileScreenState();
}

class _JSProfileScreenState extends State<EmployeeScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  List<JSPopularCompanyModel> reviewDraftList = getReviewDraftList();
  List<JSPopularCompanyModel> skillList = getSkillList();

  TabController? controller;

  @override
  void initState() {
    super.initState();
    init();
  }
  var user = {}; var jobs = {};bool user_loading = false;
  //List<Education> edu = ;
  void init() async {
    String url = "https://x.smartbuybuy.com/job/index.php?get_employer=1&token=843995707f1ab94b95e85477";
    setState(() {
      loading = true;
    });
    print(url);
    final response = await http.get(Uri.parse(url));
    setState(() {
      loading = false;
      var _body = jsonDecode(response.body);
      user = _body;
      jobs = _body;
      user_loading = false;
    });
    print('object');
  }
  List<String> listOfUrls= [
    "https://cosmosmagazine.com/wp-content/uploads/2020/02/191010_nature.jpg",
    "https://scx2.b-cdn.net/gfx/news/hires/2019/2-nature.jpg",
    "https://isha.sadhguru.org/blog/wp-content/uploads/2016/05/natures-temples.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/7/77/Big_Nature_%28155420955%29.jpeg",
    "https://s23574.pcdn.co/wp-content/uploads/Singular-1140x703.jpg",
    "https://www.expatica.com/app/uploads/sites/9/2017/06/Lake-Oeschinen-1200x675.jpg",
  ];

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
            key: scaffoldKey,
            //drawer: JSDrawerScreen(),
            appBar: jsAppBar(context, backWidget: true, homeAction: true, message: false, notifications: false, bottomSheet: true, callBack: () {
              setState(() {});
              scaffoldKey.currentState!.openDrawer();
            }),
            floatingActionButton:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      primary: js_primaryColor,
                      shape: StadiumBorder()// Background color
                  ),
                  child: const Text(
                    'Buy Package',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    PostJob().launch(context);
                  },
                  style: ElevatedButton.styleFrom(
                      primary: js_primaryColor,
                      shape: StadiumBorder()// Background color
                  ),
                  child: const Text(
                    'Add Job',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
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
                        height: 100,
                        decoration: boxDecorationWithRoundedCorners(
                          boxShape: BoxShape.circle,
                          border: Border.all(color: js_primaryColor, width: 4),
                          backgroundColor: context.scaffoldBackgroundColor,
                        ),
                        padding: EdgeInsets.all(24),
                        child: CachedNetworkImage(
                          imageUrl: user['image'],
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
                                child:                               Text(user['long_name'], style: boldTextStyle(size: 22)),

                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.business, color:Theme.of(context).iconTheme.color),
                              8.width,
                              Text(user['short_name'], style: boldTextStyle()),
                            ],
                          ),
                          Row(
                              children: [
                                Icon(Icons.location_on, color:Theme.of(context).iconTheme.color),
                                8.width,
                                Text(user['location'], style: boldTextStyle(color: Colors.blue)),
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
                      Tab(child: Text("Jobs", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                      Tab(child: Text("About", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                      Tab(child: Text("Photos", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                    ],
                    controller: controller,
                  ),
                  TabBarView(
                    children: [
                      SingleChildScrollView(
                        child:  Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                25.height,
                                Container(
                                  height: 100,
                                  child:  Row(
                                    children: [
                                      Expanded(child: Card(
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8)
                                        ),
                                        child: Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[Text('Total Jobs',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),), Text('40')],
                                          ),
                                        ),
                                      )),
                                      20.width,
                                      Expanded(child: Card(
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8)
                                        ),
                                        child: Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[FlutterLogo(), Text('data')],
                                          ),
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                                25.height,
                                Container(
                                  height: 100,
                                  child:  Row(
                                    children: [
                                      Expanded(child: Card(
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8)
                                        ),
                                        child: Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[Text('Total Jobs',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),), Text('40')],
                                          ),
                                        ),
                                      )),
                                      20.width,
                                      Expanded(child: Card(
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8)
                                        ),
                                        child: Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[FlutterLogo(), Text('data')],
                                          ),
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                                25.height,
                                Container(
                                  height: 100,
                                  child:  Row(
                                    children: [
                                      Expanded(child: Card(
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8)
                                        ),
                                        child: Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[Text('Total Jobs',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),), Text('40')],
                                          ),
                                        ),
                                      )),
                                      20.width,
                                      Expanded(child: Card(
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8)
                                        ),
                                        child: Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[FlutterLogo(), Text('data')],
                                          ),
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                                300.height
                              ],
                            ),
                        ),
                      ),

                     loading? Container(): SingleChildScrollView(
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
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(jobs['job'][i]['city'], style: primaryTextStyle()),
                                        Text("Remote: ${jobs['job'][i]['remote']}", style: primaryTextStyle()),

                                      ],
                                    ),
                                    // 4.height,
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
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.school, size: 18, color: Colors.red),
                                            4.width,
                                            Text("${jobs['job'][i]['education']}", style: secondaryTextStyle()),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.watch_later_outlined, size: 18, color: gray.withOpacity(0.8)),
                                            4.width,
                                            Text("${jobs['job'][i]['kind']}", style: secondaryTextStyle()),
                                          ],
                                        ),
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
                                                  //JSHomeScreen().launch(context);
                                                },
                                                width: MediaQuery.of(context).size.width,
                                                margin: EdgeInsets.all(16),
                                                color: js_primaryColor,
                                                child: Text("Edit", style: boldTextStyle(color: white)),
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
                      Container(
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
                                      Text("Description", style: secondaryTextStyle(size: 18)),
                                      IconButton(onPressed: () {}, icon: Icon(Icons.edit, color: js_primaryColor)),
                                    ],
                                  ),
                                  Divider(height: 0, color: gray.withOpacity(0.2)),
                                ],
                              ),
                            ),
                          )
                      ),
              Container(
              child: GalleryImage(
             // key: _key,
              imageUrls: listOfUrls,
              numOfShowImages: 4,
              titleGallery: '_title',
              )
              )

                    ],
                  ).expand(),
                ],
              );
            }))
    );
  }
}
