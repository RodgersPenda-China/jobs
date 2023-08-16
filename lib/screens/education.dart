import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:intl/intl.dart';
import 'package:job_search/model/user.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:job_search/components/JSDrawerScreen.dart';
import 'package:job_search/screens/JSAddSkillFourScreen.dart';
import 'package:job_search/utils/JSColors.dart';
import 'package:job_search/utils/JSConstant.dart';
import 'package:job_search/utils/JSWidget.dart';
import 'package:job_search/main.dart';

import '../controller/home.dart';
import 'JSProfileScreen.dart';


class EducationScreen extends StatefulWidget {
  List<Education> work; int edit,id;
  EducationScreen({Key? key,required this.work,required this.edit,required this.id}) : super(key: key);

  @override
  _JSCompleteProfileThreeScreenState createState() => _JSCompleteProfileThreeScreenState();
}

class _JSCompleteProfileThreeScreenState extends State<EducationScreen> {
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

  String fromMonthValue = 'Online';
  var fromMonthItems = ['On Campus', 'Online'];

  String toMonthValue = 'Associate Degree';
  var toMonthItems = ['Associate Degree', 'Bachelor Degree','Masters Degree','Phd Degree'];
  final HtmlEditorController controller = HtmlEditorController();

  // value set to false
  bool _value = false; String from = '', to = ''; bool work_here = false;
  String title = '',company = '',position = '',category = '',work_type = 'On Campus',city = '',description = '';
  String from_format = ''; String to_format ='';String degree_type = 'Associate Degree';
  @override
  void initState() {
    super.initState();
    init();
    if(widget.edit == 1){
      title = widget.work[widget.id].title;
      company = widget.work[widget.id].school;
      position = widget.work[widget.id].degree;
      category = widget.work[widget.id].category;
      work_type = widget.work[widget.id].school_type;
      city = widget.work[widget.id].city;
      from = widget.work[widget.id].learn_from;
      if(widget.work[widget.id].learn_to == ''){_value = true;work_here = true;} else {to = widget.work[widget.id].learn_from;}
      Future.delayed(
        const Duration(seconds: 8),
            () {
          print('here!!');
          setState(
                () {
              controller.setText(widget.work[widget.id].description);

            },
          );
        },
      );
    }
    print(widget.work[widget.id].school_type); print('School Here');
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

          if(from == ''){error = true; message = 'From Date Is Empty';}
          if(to == '' && work_here == false){error = true; message = 'To Date Is Empty';}
          if(title == ''){error = true; message = 'Title Is Empty';}
          if(company == ''){error = true; message = 'Degree Type Is Empty';}
          if(degree_type == ''){error = true; message = 'Position Is Empty';}
          if(category == ''){error = true; message = 'Category Is Empty';}
          if(work_type == ''){error = true; message = 'Work Type Is Empty';}
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
            if(work_here ==  false && widget.edit == 0) {
              DateTime dt1 = DateTime.parse(from_format);
              DateTime dt2 = DateTime.parse(to_format);

              if (dt1.compareTo(dt2) == 0) {
                error = true;
                message = 'From Date and To Date Are The Same';
              }
              if (dt1.compareTo(dt2) > 0) {
                print("DT1 is after DT2");
                error = true;
                message = 'From Date is After To Date';
              }
            }
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
              String id = '';
              if(widget.work.length != 0){id = widget.work[widget.id].id;}
              await Get.find<HomeController>().education(widget.edit.toString(),id,title, company,degree_type,category,work_type,city,from,to,description);
              var results = Get.find<HomeController>().education_response;

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
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute( builder: (ctx) => JSProfileScreen()), (route) => false);

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
                    Text("Education", style: boldTextStyle(size: 20)),
                    16.height,
                    Text("* Required fields", style: secondaryTextStyle(size: 16)),
                    16.height,
                    Text("Title *", style: boldTextStyle()),
                    Container(
                      height: textFieldHeight,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 16),
                      decoration: boxDecoration(radius: 8, color: appStore.isDarkModeOn ? scaffoldDarkColor : white),
                      child: AppTextField(
                        initialValue: title,
                        onChanged: (v){title = v;},
                        //controller: jobTitleController,
                        focus: jobTitleFocus,
                        nextFocus: companyFocus,
                        textFieldType: TextFieldType.OTHER,
                        decoration: jsInputDecoration(),
                      ),
                    ),
                    16.height,
                    Text("School*", style: boldTextStyle()),
                    Container(
                      height: textFieldHeight,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 16),
                      decoration: boxDecoration(radius: 8, color: appStore.isDarkModeOn ? scaffoldDarkColor : white),
                      child: AppTextField(
                        initialValue: company,
                        onChanged: (v){company = v;},
                        // controller: companyController,
                        focus: companyFocus,
                        nextFocus: cityFocus,
                        textFieldType: TextFieldType.NAME,
                        decoration: jsInputDecoration(),
                      ),
                    ),
                    Text("Degree Type*", style: boldTextStyle()),
                    Container(
                      height: textFieldHeight,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 16),
                      decoration: boxDecoration(radius: 8, color: appStore.isDarkModeOn ? scaffoldDarkColor : white),
                      child: DropdownButton(
                        isExpanded: true,
                        underline: Container(color: Colors.transparent),
                        value: degree_type,
                        icon: Icon(Icons.keyboard_arrow_down),
                        items: toMonthItems.map((String toMonthItems) {
                          return DropdownMenuItem(
                            value: toMonthItems,
                            child: Text(toMonthItems),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            degree_type = newValue!;
                          });
                        },
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
                        selectedItem: category,
                        onChanged: (print){
                          category = print!;
                        },
                      ),
                    ),
                    Text("School Type*", style: boldTextStyle()),
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
                        initialValue: city,
                        onChanged: (v){city = v;},
                        // controller: cityController,
                        focus: cityFocus,
                        nextFocus: descriptionFocus,
                        textFieldType: TextFieldType.OTHER,
                        decoration: jsInputDecoration(),
                      ),
                    ),
                    16.height,
                    Text("Time period", style: boldTextStyle()),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: Text("I currently go to school here", style: primaryTextStyle()),
                      value: _value,
                      activeColor: js_primaryColor,
                      dense: true,
                      onChanged: (bool? newValue) {
                        print(newValue);
                        setState(() {
                          _value = newValue!; work_here = newValue;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    16.height,
                    Text("From*", style: boldTextStyle()),
                    8.height,
                    Center(child:
                    GestureDetector(
                      onTap: () async {
                        DateTime? pickedDate =  await  showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1970), lastDate: DateTime.now());
                        if(pickedDate != null ){
                          print(pickedDate);  //get the picked date in the format => 2022-07-04 00:00:00.000
                          String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                          String new_format = DateFormat('yyyy-MM-dd').format(pickedDate); //formatted date output using intl package =>  2022-07-04
                          //You can format date as per your need
                          setState(() {from  = formattedDate;from_format = new_format;});
                          //print(day);
                        }else{
                          print("Date is not selected");
                        }
                      },
                      child: Text(from == ''?"Select Date":from, style: boldTextStyle(color: Colors.blue)),),),
                    16.height,
                    work_here?Container():
                    Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:[
                          Text("To*", style: boldTextStyle()),
                          Center(child:
                          GestureDetector(
                            onTap: () async {
                              DateTime? pickedDate =  await  showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1970), lastDate: DateTime.now());
                              if(pickedDate != null ){
                                print(pickedDate);  //get the picked date in the format => 2022-07-04 00:00:00.000
                                String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                                print(formattedDate);
                                String new_format = DateFormat('yyyy-MM-dd').format(pickedDate); //formatted date output using intl package =>  2022-07-04
                                //You can format date as per your need
                                setState(() {to  = formattedDate;to_format = new_format;});
                                //print(day);
                              }else{
                                print("Date is not selected");
                              }
                            },
                            child: Text(to == ''?"Select Date":to, style: boldTextStyle(color: Colors.blue)),),),
                        ]),
                    16.height,
                    Text("Description (Recommended)", style: boldTextStyle()),
                    8.height,
                    Text(
                        "Describe what the course is all about",
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
