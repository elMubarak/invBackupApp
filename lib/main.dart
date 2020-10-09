

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:inventory_app/providers/User.dart';
import 'package:inventory_app/screens/SplashScreen.dart';
import 'package:inventory_app/utils/app_colors.dart';
import 'package:inventory_app/utils/links.dart';
import 'package:provider/provider.dart';
import 'package:inventory_app/utils/Router.dart';


void main() => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => User()),
      ],
      child: MyApp(),
    ));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink(uri: url);
    //tokenPass
    final AuthLink authLink = AuthLink(
      getToken: () async => 'Bearer $token',
      // OR
      // getToken: () => 'Bearer <YOUR_PERSONAL_ACCESS_TOKEN>',
    );
    final Link link = authLink.concat(httpLink);
    final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(
        link: link,
        cache: OptimisticCache(
          //or inMemory cache
          dataIdFromObject: typenameDataIdFromObject,
        ),
      ),
    );
    return GraphQLProvider(
      child: HomePage(),
      client: client,
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventory App',
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: AppMidPurple,
          primaryColorDark: AppDeepPurple,
          backgroundColor: AppBackground,
          buttonColor: AppMidPurple,
          disabledColor: Colors.grey[300],
          appBarTheme: AppBarTheme(
              color: AppWhite,
              iconTheme: IconThemeData(color: AppDarkAccent),
              textTheme: TextTheme(
                  title: TextStyle(color: AppDarkAccent, fontSize: 18))),
          textTheme: TextTheme(
              title: TextStyle(fontSize: 24, color: TextColor),
              subhead: TextStyle(fontSize: 19, color: TextColor),
              body1: TextStyle(fontSize: 18, color: TextColor),
              body2: TextStyle(fontSize: 16, color: TextColor),
              subtitle: TextStyle(
                  fontSize: 17, color: TextColor, fontWeight: FontWeight.w400),
              caption:
                  TextStyle(color: TextColor, fontWeight: FontWeight.w400))),
//      home: MyHomePage(title: 'Home'),
      onGenerateRoute: Routers.generateRoute,
      onUnknownRoute: (_) => MaterialPageRoute(builder: (_) => SplashScreen()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(),
    );
  }
}
// Query(
//           options: QueryOptions(
//             documentNode:
//                 gql(query), // this is the query string you just created
//             variables: {
//               'receiptNo': 0,
//             },
//             pollInterval: 10,
//           ),
//           // Just like in apollo refetch() could be used to manually trigger a refetch
//           // while fetchMore() can be used for pagination purpose
//           builder: (QueryResult result,
//               {VoidCallback refetch, FetchMore fetchMore}) {
//             if (result.hasException) {
//               return Text(result.exception.toString());
//             }

//             if (result.loading) {
//               return Text('Loading');
//             }

//             // it can be either Map or List
//             List repositories = result.data['goodsReceipts'];

//             return ListView.builder(
//                 itemCount: repositories.length,
//                 itemBuilder: (context, index) {
//                   final repository = repositories[index];

//                   return Text(repository['receiptNo']);
//                 });
//           },
//         ),
