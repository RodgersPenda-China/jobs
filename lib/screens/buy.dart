import 'dart:async';
import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:job_search/components/JSDrawerScreen.dart';
import 'package:job_search/components/JSSettingComponent.dart';
import 'package:job_search/main.dart';
import 'package:job_search/utils/JSColors.dart';
import 'package:job_search/utils/JSWidget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;

import 'package:url_launcher/url_launcher.dart';

import '../utils/info.dart';
import 'compamy.dart';

class BuyScreen extends StatefulWidget {
  BuyScreen({Key? key}) : super(key: key);

  @override
  _JSSettingScreenState createState() => _JSSettingScreenState();
}

class _JSSettingScreenState extends State<BuyScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  late String terms;
  @override
  void initState() {
    super.initState();
    //payments - Mobile Money
    init();
  }
  String phone = ''; var res = {};  bool loading = false; bool b_loading = true;

  void init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String url = "http://api.ioevisa.net/api/job/index.php?get_my_package=1&token=${token}";
    setState(() {
      b_loading = true;
    });
    print(url);
    final response = await http.get(Uri.parse(url));
    setState(() {
      res = jsonDecode(response.body);
      b_loading = false;
    });
    print(res);
  }
  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }
  late Timer mytimer;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        drawer: JSDrawerScreen(),
        appBar: jsAppBar(context, notifications: false, message: false, bottomSheet: false, backWidget: true, homeAction: false, callBack: () {
          setState(() {});
          scaffoldKey.currentState!.openDrawer();
        }),
        body: b_loading?Center(child: CircularProgressIndicator(color: Colors.blue,),):
        SingleChildScrollView( child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.height,
            Text('Subscription', style: boldTextStyle(size:  28)).paddingOnly(left: 16),
            8.height,
            //print html
            Padding(padding: EdgeInsets.only(left: 10,right: 10),
                child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 100,
                      child:Row(
                        children: [
                          Expanded(child:
                          GestureDetector(
                              onTap: (){
                                BuyScreen().launch(context);
                              },
                              child:
                              Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text('Remaining Posts',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                      Text('${res['jobs']}')
                                    ],
                                  ),
                                ),
                              ))),
                          Expanded(child:
                          GestureDetector(
                              onTap: (){
                                BuyScreen().launch(context);
                              },
                              child:
                              Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text('Remaining Views',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                      Text('${res['candidate']}')
                                    ],
                                  ),
                                ),
                              ))),
                        ],
                      )
                      ,
                    ),
                    GestureDetector(
                        onTap: (){
                          BuyScreen().launch(context);
                        },
                        child:
                       Container(
                         height: 450,
                         width: 500,
                         child:Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)
                          ),
                          child:  Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center( child:Text('BUY PACKAGE',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)),
                                Padding(padding: EdgeInsets.only(left: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('- Post Jobs (+10)'),
                                      Text('- View Candidates Details (+5)'),
                                    ],
                                  ),
                                ),
                                16.height,
                                Text("Long Name *", style: boldTextStyle()),
                                Container(
                                  height: 60,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(top: 16),
                                  decoration: boxDecoration(radius: 8, color: appStore.isDarkModeOn ? scaffoldDarkColor : white),
                                  child: AppTextField(
                                    onChanged: (v){phone = v;},
                                    decoration: InputDecoration(
                                        labelText: 'Mobile Money (Airtel/Mtn/Zamtel)',
                                        prefix: Text('26'),
                                        floatingLabelBehavior: FloatingLabelBehavior.always),
                                    textFieldType: TextFieldType.NAME,
                                  ),
                                ),
                                10.height,
                                Text('Please Know You Have Free 5 Job Posts And 2 Candidates Views When You Create An Account',style: TextStyle(color: Colors.green),),
                               10.height,
                                Center(child: Text('When You Press Pay Now, Please Wait While',style: TextStyle(color: Colors.red),)),
                                Center(child: Text('The System Initaiiates Payment',style: TextStyle(color: Colors.red),)),
                                30.height,
                                AppButton(
                                    onTap: () async {
                                      if(loading){return;}
                                      //make payment round one
                                      if(phone.length != 10){
                                        final snackBar = SnackBar(
                                          elevation: 0,
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor: Colors.transparent,
                                          content: AwesomeSnackbarContent(
                                            title: 'Error',
                                            message:'Number Must Be 10 Digits',
                                            contentType: ContentType.failure,
                                          ),
                                        );
                                        ScaffoldMessenger.of(context)
                                          ..hideCurrentSnackBar()
                                          ..showSnackBar(snackBar);
                                        return;
                                      }

                                      final SharedPreferences prefs = await SharedPreferences.getInstance();
                                      String? token = prefs.getString('token');
                                      String url = "http://api.ioevisa.net/api/job/index.php?buy_package=1&amount=50&token=${token}&wallet=${phone}";
                                      setState(() {
                                        loading = true;
                                      });
                                      print(url);
                                      final response = await http.get(Uri.parse(url));
                                      var result = jsonDecode(response.body);
                                      if(result['error'] == 1){
                                        final snackBar = SnackBar(
                                          elevation: 0,
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor: Colors.transparent,
                                          content: AwesomeSnackbarContent(
                                            title: 'Error',
                                            message:result['message'],
                                            contentType: ContentType.failure,
                                          ),
                                        );
                                        ScaffoldMessenger.of(context)
                                          ..hideCurrentSnackBar()
                                          ..showSnackBar(snackBar);
                                      } else {
                                        print('Reahed Here');
                                        String trans = result['trans'];
                                        EasyLoading.show(status: 'Please Approve On Mobile...');
                                        mytimer = Timer.periodic(Duration(seconds: 20), (timer) async {
                                          print('https://bus.ioevisa.net/api/index.php?status=1&trans=${trans}');
                                          var _response = await http.get(
                                            Uri.parse('https://bus.ioevisa.net/api/index.php?status=1&trans=${trans}'),
                                          );
                                          var bx = jsonDecode(_response.body);
                                          if(bx['error'] == 0){
                                            print(bx['status']);
                                            if(bx["status"] == "TXN_AUTH_UNSUCCESSFUL"){
                                              EasyLoading.dismiss();
                                              EasyLoading.showToast('Transaction Failed');
                                              setState(() {
                                                loading = false;
                                              });
                                            } else if(bx['status'] == 'TXN_AUTH_SUCCESSFUL'){

                                              EasyLoading.dismiss();
                                              EasyLoading.showToast('Transaction Failed');
                                              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute( builder: (ctx) => EmployeeScreen()), (route) => false);

                                            }
                                            mytimer.cancel();
                                          }
                                        });

                                      }
                                    },
                                    color: js_primaryColor,
                                    child:Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                       loading?CircularProgressIndicator(color: Colors.white,): Text("Buy Package", style: boldTextStyle(color: white)),
                                        8.width,
                                        // CircularProgressIndicator(color: Colors.white,),
                                      ],
                                    )
                                ),
                              ],
                            ),
                          ),
                        )),
                  ],
                )),
          ],
        ).paddingOnly(bottom: 16),
        ));
  }
}
