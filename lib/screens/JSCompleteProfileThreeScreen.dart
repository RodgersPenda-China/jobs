import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:job_search/components/JSDrawerScreen.dart';
import 'package:job_search/screens/JSAddSkillFourScreen.dart';
import 'package:job_search/utils/JSColors.dart';
import 'package:job_search/utils/JSConstant.dart';
import 'package:job_search/utils/JSWidget.dart';
import 'package:job_search/main.dart';


class JSCompleteProfileThreeScreen extends StatefulWidget {
  const JSCompleteProfileThreeScreen({Key? key}) : super(key: key);

  @override
  _JSCompleteProfileThreeScreenState createState() => _JSCompleteProfileThreeScreenState();
}

class _JSCompleteProfileThreeScreenState extends State<JSCompleteProfileThreeScreen> {
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

  String fromMonthValue = 'January';
  String fromYearValue = '2021';

  String toMonthValue = 'February';
  String toYearValue = '2022';

  var fromMonthItems = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
  var fromYearItems = ['2010','2011','2012','2013','2014','2015','2016','2017','2018', '2019', '2020', '2021', '2022','2023'];

  var toMonthItems = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

  var toYearItems = ['2010','2011','2012','2013','2014','2015','2016','2017','2018', '2019', '2020', '2021', '2022','2023'];
  final HtmlEditorController controller = HtmlEditorController();
  String result = '';
  // value set to false
  bool _value = false;bool isLoading = true;

  @override
  void initState() {
    setValue();

    super.initState();
    setValueNow();
  }

  setValueNow() async {
    Future.delayed(
      Duration.zero,
          () {
        // controller.setText(widget.description!);
      },
    );
  }

  setValue() async {
    Future.delayed(
      const Duration(seconds: 4),
          () {
        setState(
              () {
            isLoading = false;
          },
        );
      },
    );

    Future.delayed(
      const Duration(seconds: 6),
          () {
        setState(
              () {},
        );
      },
    );
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  @override
  Widget build(BuildContext context) {
    controller.setText('Add Job Description');
    return GestureDetector(
      onTap: () {
        if (!kIsWeb) {
          controller.clearFocus(); // for close keybord
        }
      },
      child: Scaffold(
        // appBar: [Text('Welcome'),
        backgroundColor: white,
        resizeToAvoidBottomInset: true,
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              backgroundColor: white,
              onPressed: () {
                controller.clear();
              },
              child: Text(
                "Clear",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 20),
            FloatingActionButton(
              backgroundColor: white,
              onPressed: () {
                Navigator.of(context).pop(result);
              },
              child: Text("SAVE_LBL",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
        body: isLoading
            ? Text('Loading'):
       SingleChildScrollView(child:
       Column( children:[
         SizedBox(height: 90,),
         Text("Job Title *", style: boldTextStyle()),
         Padding(padding: EdgeInsets.all(20),
         child:    Container(
           height: textFieldHeight,
           alignment: Alignment.center,
           margin: EdgeInsets.only(top: 16),
           decoration: boxDecoration(radius: 8, color: appStore.isDarkModeOn ? scaffoldDarkColor : white),
           child: AppTextField(
             controller: companyController,
             focus: companyFocus,
             nextFocus: cityFocus,
             textFieldType: TextFieldType.NAME,
             decoration: jsInputDecoration(),
           ),
         ),
         ),

         Text("Company", style: boldTextStyle()),
         16.height,
         Row(
           children: [
             Column(
               children: [
                 Text('Category'),
                 Padding(padding: EdgeInsets.only(left: 10),
           child:
                 Container(
                   width: context.width() * 0.5,
                   decoration: boxDecorationWithRoundedCorners(
                     border: Border.all(color: gray.withOpacity(0.4)),
                     backgroundColor: appStore.isDarkModeOn ? scaffoldDarkColor : white,
                   ),
                   padding: EdgeInsets.symmetric(horizontal: 20),
                   child: DropdownButton(
                     isExpanded: true,
                     underline: Container(color: Colors.transparent),
                     value: fromMonthValue,
                     icon: Icon(Icons.keyboard_arrow_down),
                     items: fromMonthItems.map((String fromMonthItems) {
                       return DropdownMenuItem(
                         value: fromMonthItems,
                         child: Text(fromMonthItems),
                       );
                     }).toList(),
                     onChanged: (String? newValue) {
                       setState(() {
                         fromMonthValue = newValue!;
                       });
                     },
                   ),
                 )),
               ],
             ),
             12.width,
             Column(
               children: [
                 Text('Type'),
                 Container(
                   width: context.width() * 0.4,
                   decoration: boxDecorationWithRoundedCorners(
                     border: Border.all(color: gray.withOpacity(0.4)),
                     backgroundColor: appStore.isDarkModeOn ? scaffoldDarkColor : white,
                   ),
                   padding: EdgeInsets.symmetric(horizontal: 8),
                   child: DropdownButton(
                     isExpanded: true,
                     underline: Container(color: Colors.transparent),
                     value: fromYearValue,
                     icon: Icon(Icons.keyboard_arrow_down),
                     items: fromYearItems.map((String fromYearItems) {
                       return DropdownMenuItem(
                         value: fromYearItems,
                         child: Text(fromYearItems),
                       );
                     }).toList(),
                     onChanged: (String? newValue) {
                       setState(() {
                         fromYearValue = newValue!;
                       });
                     },
                   ),
                 ),
               ],
             ),

           ],
         ),
         16.height,
         Text("Details", style: boldTextStyle()),
         Container( height: 580, child:
        HtmlEditor(
          controller: controller,
          htmlEditorOptions: HtmlEditorOptions(
            autoAdjustHeight: true,
            hint:  'Please Enter Product Description here...!',
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
            buttonColor: Colors.blue,
            buttonFocusColor: Colors.black,
            buttonBorderColor: Colors.red,
            buttonFillColor: Colors.blue,
            dropdownIconColor: Colors.blue,
            dropdownIconSize: 26,
            textStyle: const TextStyle(
              fontSize: 16,
              color: pink,
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
        ),
      ),
       ]))));

  }
}
