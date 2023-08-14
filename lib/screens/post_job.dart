import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:job_search/components/JSDrawerScreen.dart';
import 'package:job_search/screens/JSAddSkillFourScreen.dart';
import 'package:job_search/utils/JSColors.dart';
import 'package:job_search/utils/JSConstant.dart';
import 'package:job_search/utils/JSWidget.dart';
import 'package:job_search/main.dart';

import '../controller/home.dart';


class PostJob extends StatefulWidget {
  var gongzuo = [];int edit;
  PostJob({Key? key,required this.gongzuo,required this.edit}) : super(key: key);

  @override
  _JSCompleteProfileThreeScreenState createState() => _JSCompleteProfileThreeScreenState();
}

class _JSCompleteProfileThreeScreenState extends State<PostJob> {
  String text = "Initial Text";

  final GlobalKey<ScaffoldState> _scaffoldkey =  GlobalKey<ScaffoldState>();

  TextEditingController jobTitleController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  FocusNode jobTitleFocus = FocusNode();
  FocusNode companyFocus = FocusNode();
  FocusNode cityFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();

  String fromMonthValue = 'Full-Time';
  var fromMonthItems = ['Full-Time', 'Part-Time', 'Contract', 'Internship'];

 // String remoteValue = 'Yes';
  var remoteList = ['Yes', 'No'];
  final HtmlEditorController controller = HtmlEditorController();
  // String toMonthValue = 'Associate Degree';
  var educationList = ['Associate Degree', 'Bachelor Degree','Masters Degree','Phd Degree'];
  // value set to false
  bool _value = false; String from = '', to = ''; bool work_here = false;
  String title = '',salary = '',experience = '',category = '',work_type = 'Full-Time', city = '',description = '';
  String education = 'Associate Degree'; String to_format ='',remoteValue = 'Yes';
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }
  bool loading = false;
  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: jsAppBar(context, notifications: false, message: false, bottomSheet: true, backWidget: true, homeAction: true, callBack: () {
        setState(() {});
        _scaffoldkey.currentState!.openDrawer();
      }),
      floatingActionButton:  AppButton(
        color: js_primaryColor,
        width: 100,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        onTap: () async {
          bool error = false; String message = '';

         // if(from == ''){error = true; message = 'From Date Is Empty';}
          //if(to == '' && work_here == false){error = true; message = 'To Date Is Empty';}
          if(title == ''){error = true; message = 'Title Is Empty';}
          if(salary == ''){error = true; message = 'Salary Is Empty';}
          if(education == ''){error = true; message = 'Educatin Is Empty';}
          if(category == ''){error = true; message = 'Category Is Empty';}
          if(experience == ''){error = true; message = 'Work Experience Is Empty';}
          if(description == ''){error = true; message = 'Description Is Empty';}
          if(city == ''){error = true; message = 'City Is Empty';}
          //expose error and return if possible then compare dates
          if(error == true){
            final snackBar = SnackBar(
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: 'Error',
                message:message,
                contentType: ContentType.failure,
              ),
            );
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(snackBar);
          } else {
            if(error == true){
              final snackBar = SnackBar(
                elevation: 0,
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                content: AwesomeSnackbarContent(
                  title: 'Error',
                  message:message,
                  contentType: ContentType.failure,
                ),
              );
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(snackBar);
            } else {
              //now we make a request
              setState(() {loading  = true;});
               await Get.find<HomeController>().save_jobs(title, salary,experience,education,category,work_type,remoteValue,city,description);
              var results = Get.find<HomeController>().experience_reponse;

              if(results['error'] == 0){
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

                if(results['error'] == 1){
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
              setState(() {loading = false;});
            }
          }


          //  JSAddSkillFourScreen().launch(context);
        },
        shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        elevation: 0,
        child: loading?CircularProgressIndicator(color: Colors.white,):Text("Save", style: boldTextStyle(color: white)),
      ),
      drawer: JSDrawerScreen(),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                16.height,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Work experience", style: boldTextStyle(size: 20)),
                    16.height,
                    Text("* Required fields", style: secondaryTextStyle(size: 16)),
                    16.height,
                    Text("Job Title *", style: boldTextStyle()),
                    Container(
                      height: textFieldHeight,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 16),
                      decoration: boxDecoration(radius: 8, color: appStore.isDarkModeOn ? scaffoldDarkColor : white),
                      child: AppTextField(
                        onChanged: (v){title = v;},
                        controller: jobTitleController,
                        focus: jobTitleFocus,
                        nextFocus: companyFocus,
                        textFieldType: TextFieldType.OTHER,
                        decoration: jsInputDecoration(),
                      ),
                    ),
                    16.height,
                    Text("Salary (Per Month)*", style: boldTextStyle()),
                    Container(
                      height: textFieldHeight,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 16),
                      decoration: boxDecoration(radius: 8, color: appStore.isDarkModeOn ? scaffoldDarkColor : white),
                      child: AppTextField(
                        onChanged: (v){salary = v;},
                        controller: companyController,
                        focus: companyFocus,
                        nextFocus: cityFocus,
                        textFieldType: TextFieldType.NAME,
                        decoration: jsInputDecoration(),
                      ),
                    ),
                    Text("Work Experience (In Years)*", style: boldTextStyle()),
                    Container(
                      height: textFieldHeight,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 16),
                      decoration: boxDecoration(radius: 8, color: appStore.isDarkModeOn ? scaffoldDarkColor : white),
                      child: AppTextField(
                        keyboardType: TextInputType.number,
                        onChanged: (v){experience = v;},
                        // controller: companyController,
                        // focus: companyFocus,
                        nextFocus: cityFocus,
                        textFieldType: TextFieldType.NAME,
                        decoration: jsInputDecoration(),
                      ),
                    ),
                    24.height,
                    Text("Education*", style: boldTextStyle()),
                    Container(
                      height: textFieldHeight,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 16),
                      decoration: boxDecoration(radius: 8, color: appStore.isDarkModeOn ? scaffoldDarkColor : white),
                      child: Container(
                        // height: 80,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 16),
                        decoration: boxDecoration(radius: 8, color: appStore.isDarkModeOn ? scaffoldDarkColor : white),
                        child: DropdownButton(
                          isExpanded: true,
                          underline: Container(color: Colors.transparent),
                          value: education,
                          icon: Icon(Icons.keyboard_arrow_down),
                          items: educationList.map((String education) {
                            return DropdownMenuItem(
                              value: education,
                              child: Text(education),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              education = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                    Text("Category*", style: boldTextStyle()),
                    Container(
                      height: 80,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 16),
                      decoration: boxDecoration(radius: 8, color: appStore.isDarkModeOn ? scaffoldDarkColor : white),
                      child: DropdownSearch<String>(
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(labelText: "Search By Place Name"),
                        ),
                        popupProps: PopupProps.modalBottomSheet(
                            showSearchBox: true
                        ),
                        asyncItems: (String filter) => Get.find<HomeController>().get_categories(),
                        onChanged: (print){
                          category = print!;
                        },
                      ),
                    ),
                    Text("work_type*", style: boldTextStyle()),
                    Container(
                      height: textFieldHeight,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 16),
                      decoration: boxDecoration(radius: 8, color: appStore.isDarkModeOn ? scaffoldDarkColor : white),
                      child: Container(
                        // height: 80,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 16),
                        decoration: boxDecoration(radius: 8, color: appStore.isDarkModeOn ? scaffoldDarkColor : white),
                        child: DropdownButton(
                          isExpanded: true,
                          underline: Container(color: Colors.transparent),
                          value: work_type,
                          icon: Icon(Icons.keyboard_arrow_down),
                          items: fromMonthItems.map((String fromMonthItems) {
                            return DropdownMenuItem(
                              value: fromMonthItems,
                              child: Text(fromMonthItems),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              work_type = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                    24.height,
                    Text("Remote*", style: boldTextStyle()),
                    Container(
                      height: textFieldHeight,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 16),
                      decoration: boxDecoration(radius: 8, color: appStore.isDarkModeOn ? scaffoldDarkColor : white),
                      child: Container(
                        // height: 80,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 16),
                        decoration: boxDecoration(radius: 8, color: appStore.isDarkModeOn ? scaffoldDarkColor : white),
                        child: DropdownButton(
                          isExpanded: true,
                          underline: Container(color: Colors.transparent),
                          value: remoteValue,
                          icon: Icon(Icons.keyboard_arrow_down),
                          items: remoteList.map((String remoteValue) {
                            return DropdownMenuItem(
                              value: remoteValue,
                              child: Text(remoteValue),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              remoteValue = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                    16.height,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("City*", style: boldTextStyle()),
                          ],
                        ),
                        8.height,
                        Text("e.g Ndola", style: secondaryTextStyle()),
                      ],
                    ),
                    Container(
                      height: textFieldHeight,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 16),
                      decoration: boxDecoration(radius: 8, color: appStore.isDarkModeOn ? scaffoldDarkColor : white),
                      child: AppTextField(
                        onChanged: (v){city = v;},
                        controller: cityController,
                        focus: cityFocus,
                        nextFocus: descriptionFocus,
                        textFieldType: TextFieldType.OTHER,
                        decoration: jsInputDecoration(),
                      ),
                    ),
                   // 16.height,

                    16.height,
                    Text("Description (Recommended)", style: boldTextStyle()),
                    8.height,
                    Text(
                        "Describe your job tasks about your achievement, and show  off what skill set your apart. This information will help prove insight into your background and showcase "
                            "compatibility as potential employee.",
                        style: secondaryTextStyle()),
                    16.height,
                    HtmlEditor(
                      controller: controller,
                      htmlEditorOptions: HtmlEditorOptions(
                        autoAdjustHeight: true,
                        hint:  'Describe Yourself',
                        shouldEnsureVisible: true,
                        adjustHeightForKeyboard: true,
                      ),
                      htmlToolbarOptions: HtmlToolbarOptions(
                        toolbarPosition: ToolbarPosition.aboveEditor,
                        toolbarType: ToolbarType.nativeGrid,
                        //by default
                        gridViewHorizontalSpacing: 0,
                        gridViewVerticalSpacing: 0,
                        dropdownBackgroundColor: Colors.white60,
                        toolbarItemHeight: 40,
                        buttonColor: Colors.black,
                        buttonFocusColor: Colors.black,
                        buttonBorderColor: Colors.red,
                        buttonFillColor: Colors.blue,
                        dropdownIconColor: Colors.blue,
                        dropdownIconSize: 26,
                        textStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        onDropdownChanged: (DropdownType type, dynamic changed,
                            Function(dynamic)? updateSelectedItem) {
                          return true;
                        },
                        mediaLinkInsertInterceptor:
                            (String url, InsertFileType type) {
                          return true;
                        },
                        mediaUploadInterceptor:
                            (PlatformFile file, InsertFileType type) async {
                          return true;
                        },
                      ),
                      otherOptions: OtherOptions(
                        height: 550,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.white,
                        ),
                      ),
                      callbacks: Callbacks(
                        onBeforeCommand: (String? currentHtml) {},
                        onChangeContent: (String? changed) {
                          setState(() {
                            description = changed!;

                          });
                        },
                        onChangeCodeview: (String? changed) {
                          // print(changed); print('kuno');

                        },
                        onNavigationRequestMobile: (String url) {
                          return NavigationActionPolicy.ALLOW;
                        },
                      ),
                    ),
                  ],
                ).paddingOnly(left: 16, right: 16, top: 8, bottom: 85),
              ],
            ),
          ),
          /*   Positioned(
            left: 16,
            bottom: 16,
            child: AppButton(
              color: js_primaryColor,
              width: 100,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              onTap: () {
                JSAddSkillFourScreen().launch(context);
              },
              shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
              elevation: 0,
              child: Text("Save", style: boldTextStyle(color: white)),
            ),
          ),*/
        ],
      ),
    );
  }
}
