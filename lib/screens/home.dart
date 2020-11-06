import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:weed_journal/screens/add-strain.dart';
import 'package:weed_journal/screens/all-strains.dart';
import 'package:weed_journal/screens/saved-strains.dart';
import 'package:weed_journal/widgets/custom-text.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{
  TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = new TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,designSize: Size(720, 1520), allowFontScaling: false);
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: CustomText(text: 'Home'),
          bottom: TabBar(
          indicatorColor: Colors.white,
          controller: tabController,
          tabs: <Widget>[
            Tab(child: CustomText(text: 'All Strains')),
            Tab(child: CustomText(text: 'Add a Strain')),
            Tab(child: CustomText(text: 'Saved Strains')),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: <Widget>[
          AllStrains(),
          AddStrain(),
          SavedStrains(),
        ],
      ),
    );
  }
}
