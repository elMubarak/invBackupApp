import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inventory_app/utils/app_colors.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final horizontalContentPadding = 24.0;
  @override
  Widget build(BuildContext context) {
    final cardWidth =
        MediaQuery.of(context).size.width * .5 - horizontalContentPadding;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Home',
            style: TextStyle(color: AppDarkAccent),
          ),
          backgroundColor: AppWhite,
          iconTheme: IconThemeData(color: AppDarkAccent),
        ),
        drawer: Drawer(),
        body: Container(
          padding: EdgeInsets.symmetric(
              horizontal: horizontalContentPadding, vertical: 30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Text(
                    'What store action would you like to carry out',
                    style: Theme.of(context)
                        .textTheme
                        .body1
                        .copyWith(fontWeight: FontWeight.w500, fontSize: 22),
                  ),
                ),
                SizedBox(height: 24),
                Card(
                  child: GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed('/inbound');
                        },
                        child: GridTile(
                          child: Container(
                            height: 20,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: AppWhite,
                              border: Border(
                                right: BorderSide(
                                    color: Color(0xFFF0F4F8), width: 2),
                                bottom: BorderSide(
                                    color: Color(0xFFF0F4F8), width: 2),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.asset('assets/images/inbound.svg'),
                                SizedBox(height: 14),
                                Text(
                                  'Inbound',
                                  style: Theme.of(context)
                                      .textTheme
                                      .body1
                                      .copyWith(fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        child: GridTile(
                          child: Container(
                            height: 20,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: AppWhite,
                              border: Border(
                                bottom: BorderSide(
                                    color: Color(0xFFF0F4F8), width: 2),
                              ),
                            ),
                            child:
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SvgPicture.asset('assets/images/outbound.svg'),
                                    SizedBox(height: 14),
                                    Text(
                                      'Outbound',
                                      style: Theme.of(context)
                                          .textTheme
                                          .body1
                                          .copyWith(fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed('/outbound');
                        },
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed('/scan-single-item');
                        },
                        child: GridTile(
                          child: Container(
                            height: 20,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: AppWhite,
                              border: Border(
                                right: BorderSide(
                                    color: Color(0xFFF0F4F8), width: 2),
                                bottom: BorderSide(
                                    color: Color(0xFFF0F4F8), width: 2),
                              ),
                            ),
                            child:
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SvgPicture.asset('assets/images/scan-item.svg'),
                                    SizedBox(height: 14),
                                    Text(
                                      'Scan Item',
                                      style: Theme.of(context)
                                          .textTheme
                                          .body1
                                          .copyWith(fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () =>
                            Navigator.of(context).pushNamed('/stock-count'),
                        child: GridTile(
                          child: Container(
                            height: 20,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: AppWhite,
                              border: Border(
                                bottom: BorderSide(
                                    color: Color(0xFFF0F4F8), width: 2),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.asset(
                                    'assets/images/stock-count.svg'),
                                SizedBox(height: 14),
                                Text(
                                  'Stock Count',
                                  style: Theme.of(context)
                                      .textTheme
                                      .body1
                                      .copyWith(fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () =>
                            Navigator.of(context).pushNamed('/stock-transfer'),
                        child: GridTile(
                          child: Container(
                            height: 20,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: AppWhite,
                              border: Border(
                                right: BorderSide(
                                    color: Color(0xFFF0F4F8), width: 2),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.asset(
                                    'assets/images/stock-transfer.svg'),
                                SizedBox(height: 14),
                                Text(
                                  'Stock Transfer',
                                  style: Theme.of(context)
                                      .textTheme
                                      .body1
                                      .copyWith(fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () =>
                            Navigator.of(context).pushNamed('/remove-goods'),
                        child: GridTile(
                          child: Container(
                            height: 20,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: AppWhite,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.asset(
                                    'assets/images/remove-goods.svg'),
                                SizedBox(height: 14),
                                Text(
                                  'Remove Ex Goods',
                                  style: Theme.of(context)
                                      .textTheme
                                      .body1
                                      .copyWith(fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
