import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inventory_app/screens/outbound/ReturnToVendorScreen.dart';
import 'package:inventory_app/utils/app_colors.dart';

class OutboundScreen extends StatefulWidget {
  @override
  _OutboundScreenState createState() => _OutboundScreenState();
}

class _OutboundScreenState extends State<OutboundScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Outbound'),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Outbound', style: Theme.of(context).textTheme.title),
              SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * .8,
                child: Text(
                    "Select any of the following processes to outbound items",
                    style: Theme.of(context).textTheme.body1),
              ),
              SizedBox(height: 30),
              RaisedButton(
                color: Color(0xFF239374),
                padding: EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0)),
                onPressed: () {
                  Navigator.of(context).pushNamed('/outbound-ticket');
                },
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Outbound',
                            style: Theme.of(context).textTheme.body1.copyWith(
                                fontWeight: FontWeight.w700, color: AppWhite),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Outbound goods from the store warehouse',
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
                          color: AppLightAccentGreen,
                          borderRadius: BorderRadius.circular(8)),
                      child: SvgPicture.asset('assets/icons/store-items.svg'),
                    )
                  ],
                ),
              ),
              SizedBox(height: 30),
              RaisedButton(
                color: Color(0xFF239374),
                padding: EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0)),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => VendorReturnScreen()));
                },
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Return To Vendor',
                            style: Theme.of(context).textTheme.body1.copyWith(
                                fontWeight: FontWeight.w700, color: AppWhite),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Return C&I or consignment back to vendor',
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
                          color: AppLightAccentGreen,
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
