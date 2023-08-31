import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:job_search/components/JSPopularCompanyComponent.dart';
import 'package:job_search/components/JSDrawerScreen.dart';
import 'package:job_search/main.dart';
import 'package:job_search/screens/JSJobSearchScreen.dart';
import 'package:job_search/screens/user.dart';
import 'package:job_search/utils/JSColors.dart';
import 'package:job_search/utils/JSConstant.dart';
import 'package:job_search/utils/JSWidget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/JSPopularCompanyModel.dart';
import '../utils/JSDataGenerator.dart';
import '../utils/flutter_rating_bar.dart';
import 'JSCompanyProfileScreens.dart';


class CandidatesScreen extends StatefulWidget {
  int id;
   CandidatesScreen({Key? key,required this.id}) : super(key: key);

  @override
  _JSJobCompaniesState createState() => _JSJobCompaniesState();
}

class _JSJobCompaniesState extends State<CandidatesScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  List<JSPopularCompanyModel> popularCompanyList = getPopularCompanyData();
  @override
  void initState() {
    super.initState();
    init();
  }
  bool loading = true; var companies = [];

  void init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String url = '';
    if(widget.id == 0) {
      url = "http://api.ioevisa.net/api/job/index.php?get_candidates=1";
    } else if(widget.id == 1) {
      url = "http://api.ioevisa.net/api/job/index.php?get_my_candidates=1&token=${token}";
    } else {
      url = "http://api.ioevisa.net/api/job/index.php?get_my_applicants=1&token=${token}";
    }
    setState(() {
      loading = true;
    });
    print(url);
    final response = await http.get(Uri.parse(url));
    setState(() {
      loading = false;
      companies = json.decode(response.body);
    });
    print('object');
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: jsAppBar(context,notifications: false,message: false,bottomSheet: true,backWidget: true,homeAction: true,callBack: () {
        setState(() {});
        scaffoldKey.currentState!.openDrawer();
      }),
      drawer: JSDrawerScreen(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                16.height,
                Text("Candidates", style: boldTextStyle(size: 22)),
                8.height,
                8.height,
                widget.id == 0?SizedBox():AppButton(
                  color: js_primaryColor,
                  width: context.width(),
                  onTap: () {
                    CandidatesScreen(id: 0,).launch(context);
                  },
                  child: Text("Find Candidates", style: boldTextStyle(color: white)),
                ),
                32.height,
                loading?Shimmer.fromColors(child:         ListView.separated(
                  itemCount: 2,
                  padding: EdgeInsets.all(8),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder: (BuildContext context, int index) => Divider(),
                  itemBuilder: (context, index) {
                    JSPopularCompanyModel data = popularCompanyList[index];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            commonCachedNetworkImage(data.companyImage.validate(), height: 50, width: 50, fit: BoxFit.contain),
                            16.width,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(data.companyName.validate(), style: boldTextStyle()),
                                4.height,
                                Row(
                                  children: [
                                    Text('200 Jobs', style: secondaryTextStyle(color: js_textColor.withOpacity(0.7)))
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        6.height,
                        Row(
                          children: [
                            Icon(Icons.location_pin),
                            8.width,
                            Text('Meanwood', style: secondaryTextStyle()),
                          ],
                        ),
                      ],
                    ).onTap(() {
                      // JSCompanyProfileScreens(popularCompanyList: data).launch(context);
                    });
                  },
                ),
                    baseColor: Colors.red, highlightColor: Colors.blue):

               companies.length == 0?
                   Center(child: Text('No Data Found'),)
                   :ListView.separated(
                  itemCount: companies.length,
                  padding: EdgeInsets.all(8),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder: (BuildContext context, int index) => Divider(),
                  itemBuilder: (context, index) {
                    JSPopularCompanyModel data = popularCompanyList[index];

                    return  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: (){
                            UserScreen(id: companies[index]['id'],applicant: widget.id == 2?1:0,
                              job_id: widget.id == 2?companies[index]['job_id']:0.toString()).launch(context);
                          },
                          child: Row(
                            children: [
                              commonCachedNetworkImage(companies[index]['image'], height: 50, width: 50, fit: BoxFit.contain),
                              16.width,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(companies[index]['name'], style: boldTextStyle()),
                                  4.height,

                                  Row(
                                    children: [
                                      Container(
                                        width: 200,
                                        child:
                                        widget.id == 2? Text('Job: ${companies[index]['job']}', style: secondaryTextStyle(color: js_textColor.withOpacity(0.7)))
                                        :Text('${companies[index]['work_experience']} Experince, ${companies[index]['education']} Education', style: secondaryTextStyle(color: js_textColor.withOpacity(0.7)))

                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                        ,
                        6.height,
                        GestureDetector(
                        onTap: (){
                    launchUrl(Uri.parse('https://www.google.com/maps/dir/?api=1&destination=${companies[index]['location']}&destination_place_id=${companies[index]['place_id']}'
                    ),mode: LaunchMode.externalNonBrowserApplication,);
                    },
                    child:
                        Row(
                          children: [
                            Icon(Icons.location_on,color: Colors.blue,),
                            8.width,
                            Text('${companies[index]['location']}', style: secondaryTextStyle(color: Colors.blue)),
                          ],
                        )),
                      ],
                    ).onTap(() {
                      // JSCompanyProfileScreens(popularCompanyList: data).launch(context);
                    });
                  },
                ),
              ],
            ).paddingOnly(left: 16, right: 16, bottom: 24)
          ],
        ),
      ),
    );
  }
}
