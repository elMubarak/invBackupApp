import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inventory_app/screens/inbound/GoodsReceiptScreen.dart';
import 'package:inventory_app/utils/app_colors.dart';

class InboundScreen extends StatefulWidget {
  @override
  _InboundScreenState createState() => _InboundScreenState();
}

class _InboundScreenState extends State<InboundScreen> {
  var token;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Inbound'),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Inbound', style: Theme.of(context).textTheme.title),
              SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * .8,
                child: Text(
                    "Kindly pick any of the following actions to complete on incoming items",
                    style: Theme.of(context).textTheme.body1),
              ),
              SizedBox(height: 30),
              RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0)),
                onPressed: () {
                  Navigator.of(context).pushNamed('/view-items');
                },
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Scan Items in P.O',
                            style: Theme.of(context).textTheme.body1.copyWith(
                                fontWeight: FontWeight.w700, color: AppWhite),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Scan Items in the P.O ID/GNR into the wearhouse',
//                          overflow: TextOverflow.fade,
                            softWrap: true,
                            style: Theme.of(context).textTheme.body1.copyWith(
                                color: AppWhite, fontWeight: FontWeight.w300),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 15),
                    Container(
                      padding: EdgeInsets.all(14),
                      decoration: BoxDecoration(
                          color: AppLightAccentPurple,
                          borderRadius: BorderRadius.circular(8)),
                      child: SvgPicture.asset('assets/icons/scan-items.svg'),
                    )
                  ],
                ),
              ),
              SizedBox(height: 30),
              RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0)),
                onPressed: () {
                  Navigator.of(context).pushNamed('/put-away-grn');
                },
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Put Items Away',
                            style: Theme.of(context).textTheme.body1.copyWith(
                                fontWeight: FontWeight.w700, color: AppWhite),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Scan Inbounded items into a store location',
                            softWrap: true,
                            style: Theme.of(context).textTheme.body1.copyWith(
                                color: AppWhite, fontWeight: FontWeight.w300),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 15),
                    Container(
                      padding: EdgeInsets.all(14),
                      decoration: BoxDecoration(
                          color: AppLightAccentPurple,
                          borderRadius: BorderRadius.circular(8)),
                      child: SvgPicture.asset('assets/icons/store-items.svg'),
                    )
                  ],
                ),
              ),
              SizedBox(height: 30),
              RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0)),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => GoodsReceiptScreen(),
                    ),
                  );
                },
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Goods Receipt',
                            style: Theme.of(context).textTheme.body1.copyWith(
                                fontWeight: FontWeight.w700, color: AppWhite),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Inbound remaining goods to store',
                            softWrap: true,
                            style: Theme.of(context).textTheme.body1.copyWith(
                                color: AppWhite, fontWeight: FontWeight.w300),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 15),
                    Container(
                      padding: EdgeInsets.all(14),
                      decoration: BoxDecoration(
                          color: AppLightAccentPurple,
                          borderRadius: BorderRadius.circular(8)),
                      child: SvgPicture.asset('assets/icons/store-items.svg'),
                    )
                  ],
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    ));
  }
}
