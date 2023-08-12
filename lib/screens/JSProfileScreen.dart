import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
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

import '../components/JSReviewAndSaVeComponent.dart';
import '../controller/home.dart';
import 'JSCompleteProfileOneScreen.dart';
import 'education.dart';

class JSProfileScreen extends StatefulWidget {
  const JSProfileScreen({Key? key}) : super(key: key);

  @override
  _JSProfileScreenState createState() => _JSProfileScreenState();
}

class _JSProfileScreenState extends State<JSProfileScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  List<JSPopularCompanyModel> reviewDraftList = getReviewDraftList();
  List<JSPopularCompanyModel> skillList = getSkillList();

  TabController? controller;

  @override
  void initState() {
    super.initState();
    init();
    Get.find<HomeController>().get_user();
    Get.find<HomeController>().get_cv();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
            authController.user_loading?Shimmer.fromColors(
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
                      children: [Text(authController.user[0].name, style: boldTextStyle(size: 22)),
                        IconButton(onPressed: () {JSCompleteProfileOneScreen().launch(context);}, icon: Icon(Icons.edit, color: js_primaryColor))],
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on, color:Theme.of(context).iconTheme.color),
                        8.width,
                        Text(authController.user[0].location, style: boldTextStyle(color: Colors.blue)),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.person, color: Theme.of(context).iconTheme.color),
                        8.width,
                        Text(authController.user[0].gender, style: boldTextStyle()),
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
                Tab(child: Text("CV", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                Tab(child: Text("Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                Tab(child: Text("Description", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
              ],
              controller: controller,
            ),
            TabBarView(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.all(16),
                  decoration: boxDecorationWithRoundedCorners(
                    borderRadius: BorderRadius.circular(8),
                    backgroundColor: appStore.isDarkModeOn ? scaffoldDarkColor : js_backGroundColor,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "You can only Upload 3 cvs at a time.",
                          style: boldTextStyle(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ).paddingAll(8),
                        Divider(color: gray.withOpacity(0.4)),
                        authController.cv_loading? Shimmer.fromColors(child: Card (
                          margin: EdgeInsets.all(10),
                          shadowColor: Colors.blueGrey,
                          elevation: 10,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              for(int i = 0; i < 2;i++)
                              ListTile(
                                leading: Icon (
                                    Icons.picture_as_pdf,
                                    color: Colors.red,
                                    size: 45
                                ),
                                title: Text(
                                  "Php.pdf",
                                  style: TextStyle(fontSize: 20),
                                ),
                                trailing: Icon (
                                    Icons.close,
                                    // color: Colors.red,
                                    size: 23
                                ),
                              ),
                            ],
                          ),
                        ),
                            baseColor: gray.withOpacity(0.1), highlightColor: Colors.blue):
                       Column(
                         children: [
                           for(int i = 0; i < authController.cvs.length;i++)
                           Card (
                             margin: EdgeInsets.all(10),
                             shadowColor: Colors.blueGrey,
                             elevation: 10,
                             child: Column(
                               mainAxisSize: MainAxisSize.min,
                               children: <Widget>[
                                 ListTile(
                                   leading:
                             authController.cvs[i].split(".").last == 'png'||authController.cvs[i].split(".").last == 'jpg'
                              || authController.cvs[i].split(".").last == 'jpeg'?
                                   Icon (
                                       Icons.image,
                                       color: Colors.greenAccent,
                                       size: 45
                                   ):authController.cvs[i].split(".").last == 'pdf'?
                             Icon (
                                 Icons.picture_as_pdf,
                                 color: Colors.red,
                                 size: 45
                             ):
                             authController.cvs[i].split(".").last == 'docx'?
                             Image.asset('images/jobSearch/docx.png'):Icon (
                                 Icons.file_present,
                                 color: Colors.blueGrey,
                                 size: 45
                             ),
                                   title: Text(
                                     authController.cvs[i].split(".").last,
                                     style: TextStyle(fontSize: 20),
                                   ),
                                   trailing: Icon (
                                       Icons.close,
                                       // color: Colors.red,
                                       size: 23
                                   ),
                                 ),
                               ],
                             ),
                           ),
                           // Card (
                           //   margin: EdgeInsets.all(10),
                           //   shadowColor: Colors.blueGrey,
                           //   elevation: 10,
                           //   child: Column(
                           //     mainAxisSize: MainAxisSize.min,
                           //     children: <Widget>[
                           //       ListTile(
                           //         leading: Icon (
                           //             Icons.image,
                           //             color: Colors.greenAccent,
                           //             size: 45
                           //         ),
                           //         title: Text(
                           //           "Php.pdf",
                           //           style: TextStyle(fontSize: 20),
                           //         ),
                           //         trailing: Icon (
                           //             Icons.close,
                           //             // color: Colors.red,
                           //             size: 23
                           //         ),
                           //       ),
                           //     ],
                           //   ),
                           // ),
                           // Card (
                           //   margin: EdgeInsets.all(10),
                           //   shadowColor: Colors.blueGrey,
                           //   elevation: 10,
                           //   child: Column(
                           //     mainAxisSize: MainAxisSize.min,
                           //     children: <Widget>[
                           //       ListTile(
                           //         leading: Image.asset('images/jobSearch/docx.png'),
                           //         title: Text(
                           //           "Markejnkjnjknjkting.docx",
                           //           style: TextStyle(fontSize: 18),
                           //         ),
                           //         trailing: Icon (
                           //             Icons.image,
                           //             // color: Colors.red,
                           //             size: 23
                           //         ),
                           //       ),
                           //     ],
                           //   ),
                           // ),

                         ],
                       ),

                        24.height,
                        Center(child:
                        AppButton(
                          color: js_textColor,
                          width: 200,
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          onTap: () async {
                            //select file and upload
                            FilePickerResult? result = await FilePicker.platform.pickFiles();

                            if (result != null) {
                              File file = File(result.files.single.path!);
                              final SharedPreferences prefs = await SharedPreferences.getInstance();
                              String? token = prefs.getString('token');
                              MultipartBody _files = MultipartBody('0',file);
                              List<MultipartBody> files = [];
                              files.add(_files);
                              setState(() {loading = true;});
                             await Get.find<HomeController>().upload_cv(token!, files);
                             var cv = Get.find<HomeController>().cv_response;
                             if(cv['error'] == 0){
                               await Get.find<HomeController>().get_cv();
                             } else {
                               final snackBar = SnackBar(
                                 elevation: 0,
                                 behavior: SnackBarBehavior.floating,
                                 backgroundColor: Colors.transparent,
                                 content: AwesomeSnackbarContent(
                                   title: 'Error',
                                   message:cv['message'],
                                   contentType: ContentType.failure,
                                 ),
                               );
                               ScaffoldMessenger.of(context)
                                 ..hideCurrentSnackBar()
                                 ..showSnackBar(snackBar);
                             }
                             setState(() {loading = false;});
                            } else {

                              // User canceled the picker
                            }

                            //JSCompleteProfileFiveScreen().launch(context);
                            //Get.find<HomeController>().get_user();
                           },
                          shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                          child: loading?CircularProgressIndicator(color: Colors.white,):
                          Text("Upload", style: boldTextStyle(color: white)),
                        ),)
                      ],
                    ),
                  ),
                ),
                authController.user_loading?Container():Container(
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
                            Text(authController.user[0].name, style: boldTextStyle()),
                            16.width,
                            Icon(Icons.edit, color: js_primaryColor, size: 18),
                          ],
                        ),
                        24.height,
                        Text(authController.user[0].location, style: boldTextStyle(size: 22)),
                        8.height,
                        Row(
                          children: [
                            Icon(Icons.email, color: Theme.of(context).iconTheme.color),
                            8.width,
                            Text(authController.user[0].email, style: primaryTextStyle()),
                          ],
                        ),
                        8.height,
                        Row(
                          children: [
                            Icon(Icons.call, color: Theme.of(context).iconTheme.color),
                            8.width,
                            Text(authController.user[0].phone, style: primaryTextStyle(color: js_primaryColor, decoration: TextDecoration.underline)),
                          ],
                        ),

                        24.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Work Experience", style: secondaryTextStyle(size: 18)),
                            IconButton(onPressed: () {
                              WorkExperience().launch(context);
                            }, icon: Icon(Icons.add_circle_outline, color: js_primaryColor)),
                          ],
                        ),
                        Divider(height: 0, color: gray.withOpacity(0.2)),
                        8.height,
                        for(int i = 0;i < authController.work.length;i++)
                        Column(
                            crossAxisAlignment:  CrossAxisAlignment.start,
                            children:[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(authController.work[i].title, style: boldTextStyle()),
                                  Row(
                                    children: [
                                      IconButton(onPressed: () {}, icon: Icon(Icons.edit, color: js_primaryColor)),
                                      IconButton(onPressed: () {}, icon: Icon(Icons.delete, color: js_primaryColor)),
                                    ],
                                  ),
                                ],
                              ),
                              Text(authController.work[i].city, style: primaryTextStyle()),
                              8.height,
                              Text('${authController.work[i].work_from} to ${authController.work[i].work_to}', style: secondaryTextStyle()),
                              8.height,
                              Text(authController.work[i].work_type, style: primaryTextStyle()),
                              24.height,
                            ]),
                        24.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Education", style: secondaryTextStyle(size: 18)),
                            IconButton(onPressed: () {Education().launch(context);}, icon: Icon(Icons.add_circle_outline, color: js_primaryColor)),
                          ],
                        ),
                        Divider(height: 0, color: gray.withOpacity(0.2)),
                        8.height,
                        for(int i = 0;i < authController.edu.length;i++)
                          Column(
                              crossAxisAlignment:  CrossAxisAlignment.start,
                              children:[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(authController.edu[i].title, style: boldTextStyle()),
                                    Row(
                                      children: [
                                        IconButton(onPressed: () {}, icon: Icon(Icons.edit, color: js_primaryColor)),
                                        IconButton(onPressed: () {}, icon: Icon(Icons.delete, color: js_primaryColor)),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(authController.edu[i].city, style: primaryTextStyle()),
                                8.height,
                                Text('${authController.edu[i].learn_from} to ${authController.edu[i].learn_to}', style: secondaryTextStyle()),
                                8.height,
                                Text(authController.edu[i].school_type, style: primaryTextStyle()),
                                24.height,
                              ]),
                        24.height,
                      ],
                    ),
                  ),
                )
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
              ],
            ).expand(),
          ],
        );
        })),
    );
  }
}
