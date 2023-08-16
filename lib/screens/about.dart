import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:job_search/components/JSDrawerScreen.dart';
import 'package:job_search/components/JSSettingComponent.dart';
import 'package:job_search/main.dart';
import 'package:job_search/utils/JSWidget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/info.dart';

class AboutUs extends StatefulWidget {
  String info;
  AboutUs({Key? key,required this.info}) : super(key: key);

  @override
  _JSSettingScreenState createState() => _JSSettingScreenState();
}

class _JSSettingScreenState extends State<AboutUs> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  late String terms;
  bool loading = true;
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(() {print('here'); });
    if(widget.info == 'Terms & Conditions'){
      terms = getTerms();
    } else {
      terms = getPrivate();
    }
    loading = false;
    init();
  }
  String email = 'Please Login';
  void init() async {

  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: JSDrawerScreen(),
      appBar: jsAppBar(context, notifications: false, message: false, bottomSheet: false, backWidget: true, homeAction: false, callBack: () {
        setState(() {});
        scaffoldKey.currentState!.openDrawer();
      }),
      body:
      SingleChildScrollView(
        controller: _controller,
        child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          16.height,
          Text(widget.info, style: boldTextStyle(size: 28)).paddingOnly(left: 16),
          8.height,
          //print html
          loading? CircularProgressIndicator(color: Colors.white,):
          widget.info == 'Terms & Conditions' || widget.info == 'Privacy Policy'?
          HtmlWidget(
            // the first parameter (`html`) is required
          terms
          ,

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
            textStyle: TextStyle(fontSize: 16),

            // turn on `webView` if you need IFRAME support (it's disabled by default)
            //webView: true,
          ):
              Padding(padding: EdgeInsets.only(left: 10,right: 10),
              child:
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  16.height,
                  Center(child: Text('Company Details', style: boldTextStyle(size: 18)).paddingOnly(left: 16)),
                  Text('Company: RODGERS PENDA INNOVATION ENTERPRISE'),
                  8.height,
                  Text("Location: Lusaka,Zambia"),
                  8.height,
                  Text("Email: rodgerspenda2000@gmail.com"),
                  8.height,
                  Text("Phone/Whatsapp: +26076150340"),
                  16.height,
                  Center(child: Text('Project Details', style: boldTextStyle(size: 18)).paddingOnly(left: 16)),
                  Text('Operation Name: IOE-VISA'),
                  8.height,
                  Text("Project: Main"),
                  8.height,
                  Text("Item: Jobs"),
                  20.height,
                  AppButton(
                    onTap: (){
                      launchUrl(Uri.parse('https://wa.me/26076150340?text=Hello,%20Am%20Interested%20In%20Your%20Jobs App.%20Thanks')
                      ,mode: LaunchMode.externalApplication);
                    },
                      color: Colors.green,
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Add Whatsapp", style: boldTextStyle(color: white)),
                          8.width,
                          // CircularProgressIndicator(color: Colors.white,),
                        ],
                      )
                  ),
                ],
              )),
        ],
      ).paddingOnly(bottom: 16),
    ));
  }
}
