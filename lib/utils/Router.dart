import 'package:flutter/material.dart';
import 'package:inventory_app/screens/HomeScreen.dart';
import 'package:inventory_app/screens/LoginScreen.dart';
import 'package:inventory_app/screens/SplashScreen.dart';
import 'package:inventory_app/screens/inbound/InboundScreen.dart';
import 'package:inventory_app/screens/inbound/PutAwayScreen.dart';
import 'package:inventory_app/screens/inbound/PutAwayScreenGrn.dart';
import 'package:inventory_app/screens/inbound/ScanIntoLocationScreen.dart';
import 'package:inventory_app/screens/inbound/ScanIntoLocationSuccessScreen.dart';
import 'package:inventory_app/screens/inbound/ScanScreen.dart';
import 'package:inventory_app/screens/inbound/ScanSuccessScreen.dart';
import 'package:inventory_app/screens/inbound/ScanToLocation.dart';
import 'package:inventory_app/screens/inbound/ViewItemsScreen.dart';
import 'package:inventory_app/screens/outbound/OuboundScreen.dart';
import 'package:inventory_app/screens/outbound/OuboundTicketScreen.dart';
import 'package:inventory_app/screens/outbound/ScanLocationScreen.dart';
import 'package:inventory_app/screens/remove-goods/RemoveGoodsScreen.dart';
import 'package:inventory_app/screens/scan-items/ScanSingleItemScreen.dart';
import 'package:inventory_app/screens/stock-count/StockCountScreen.dart';
import 'package:inventory_app/screens/stock-transfer/StockTransferScreen.dart';

const initialRoute = '/';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initialRoute:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/auth':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case '/inbound':
        return MaterialPageRoute(builder: (_) => InboundScreen());
      case '/outbound':
        return MaterialPageRoute(builder: (_) => OutboundScreen());
      case '/view-items':
        return MaterialPageRoute(builder: (_) => ViewItemsScreen());
      case '/scanner':
        return MaterialPageRoute(
            builder: (_) => ScanScreen(
                  data: settings.arguments,
                ));
      case '/put-away-grn':
        return MaterialPageRoute(builder: (_) => PutAwayScreenGrn());
      case '/put-away':
        return MaterialPageRoute(
            builder: (_) => PutAwayScreen(
                  data: settings.arguments,
                ));
      case '/location-scan-entry':
        return MaterialPageRoute(
            builder: (_) => ScanToLocationScreen(
                  locationID: settings.arguments,
                ));
      case '/location-scan-items':
        return MaterialPageRoute(
            builder: (_) => ScanIntoLocationScreen(
                  locationID: settings.arguments,
                ));
      case '/location-scan-success':
        return MaterialPageRoute(
            builder: (_) => ScanIntoLocationSuccessScreen(
                  locationID: settings.arguments,
                ));
      case '/scanner-success':
        return MaterialPageRoute(builder: (_) => ScanSuccessScreen(0,""));
      case '/outbound-ticket':
        return MaterialPageRoute(builder: (_) => OutboundTicketScreen());
      case '/outbound-location-scan':
        return MaterialPageRoute(builder: (_) => ScanLocationScreenOutbound());
      case '/scan-single-item':
        return MaterialPageRoute(builder: (_) => ScanItemScreen());
      case '/stock-count':
        return MaterialPageRoute(builder: (_) => StockCountScreen());
      case '/stock-transfer':
        return MaterialPageRoute(builder: (_) => StockTransferScreen());
      case '/remove-goods':
        return MaterialPageRoute(builder: (_) => RemoveGoodsScreen());
      default:
        return MaterialPageRoute(builder: (_) => Scaffold());
    }
  }
}
