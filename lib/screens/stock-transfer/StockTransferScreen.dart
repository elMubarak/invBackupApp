import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inventory_app/screens/outbound/ReturnToVendorScreen.dart';
import 'package:inventory_app/screens/stock-transfer/InterTransferScreen.dart';
import 'package:inventory_app/screens/stock-transfer/IntraTransferScreen.dart';
import 'package:inventory_app/utils/app_colors.dart';

class StockTransferScreen extends StatefulWidget {
  @override
  _StockTransferScreenState createState() => _StockTransferScreenState();
}

class _StockTransferScreenState extends State<StockTransferScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Stock Transfer'),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Stock Transfer', style: Theme.of(context).textTheme.title),
              SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * .8,
                child: Text(
                    "Transfer stock from one location to another "
                    "between or within the store",
                    style: Theme.of(context).textTheme.body1),
              ),
              SizedBox(height: 30),
              RaisedButton(
                color: Color(0xFF239374),
                padding: EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0)),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => IntraTransferScreen()));
                },
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Intra Warehouse Transfer',
                            style: Theme.of(context).textTheme.body1.copyWith(
                                fontWeight: FontWeight.w700, color: AppWhite),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Move items within the warehouse',
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
                      MaterialPageRoute(builder: (_) => InterTransferScreen()));
                },
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Inter Warehouse Transfer',
                            style: Theme.of(context).textTheme.body1.copyWith(
                                fontWeight: FontWeight.w700, color: AppWhite),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Move items from one warehouse to another',
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
