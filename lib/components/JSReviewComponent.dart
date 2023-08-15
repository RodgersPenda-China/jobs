import 'package:flutter/material.dart';
import 'package:job_search/model/JSPopularCompanyModel.dart';
import 'package:job_search/utils/JSColors.dart';
import 'package:job_search/utils/JSDataGenerator.dart';
import 'package:nb_utils/nb_utils.dart';

class JSReviewComponent extends StatefulWidget {

  @override
  _JSReviewComponentState createState() => _JSReviewComponentState();
}

class _JSReviewComponentState extends State<JSReviewComponent> {

  List<JSPopularCompanyModel> questionList = getQuestionList();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
      itemCount: questionList.length,
      padding: EdgeInsets.symmetric(horizontal: 8),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        JSPopularCompanyModel data = questionList[index];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.companyName.validate(),
              style: boldTextStyle(size: 18),
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
            16.height,
            Text(
              data.totalDays.validate(),
              style: primaryTextStyle(),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            8.height,
          ],
        ).paddingAll(16);
      },
    );
  }
}
