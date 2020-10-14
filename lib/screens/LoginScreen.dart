import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:inventory_app/graphQL/requests.dart';
import 'package:inventory_app/screens/utils/BottomClipper.dart';
import 'package:inventory_app/utils/Constants.dart';
import 'package:inventory_app/utils/app_colors.dart';
import 'package:toast/toast.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  bool _obscureText = true;

  var requests = Requests();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Mutation(
          options: MutationOptions(
            documentNode: gql(
              requests.login(),
            ),
            update: (Cache cache, QueryResult result) {
              return cache;
            },
            onCompleted: (dynamic result) {
              var data = jsonEncode(result);
              print("On Complete : ${jsonEncode(result)}");
              var newResult = jsonDecode(data);
              var email = newResult['authenticate']['email'];
              setState(() {
                Constants.contactName =
                    newResult['authenticate']['contactName'];
              });
              if (email == null) {
                Toast.show("Please check credentials", context);
              } else {
                Navigator.of(context).pushReplacementNamed('/home');
              }
            },
          ),
          builder: (RunMutation runMutation, QueryResult result) {
            if (result.hasException) {
              Toast.show("Please check network connection", context);
            }
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top),
                child: Column(
//              mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
//                  height: MediaQuery.of(context).size.height * .5,
                      width: double.infinity,
//                color: AppLightPurple,

                      child: ClipPath(
                        child: Container(
                          padding: EdgeInsets.only(bottom: 70, top: 20),
                          color: AppWhite,
                          child: Column(
                            children: <Widget>[
                              SvgPicture.asset(
                                'assets/images/full-robot.svg',
                                height:
                                    MediaQuery.of(context).size.height * .23,
                              ),
                              SizedBox(height: 15),
                              Text(
                                'Welcome back',
                                style: Theme.of(context).textTheme.title,
                              ),
                              SizedBox(height: 15),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Text(
                                  'Kindly login with your credentials to use the scanner',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        clipper: BottomWaveClipper(),
                      ),
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        children: <Widget>[
                          _buildCustomTextField(_usernameController),
                          SizedBox(height: 25),
                          TextField(
                            controller: _passwordController,
                            style: Theme.of(context).textTheme.body1,
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              suffixIcon: InkWell(
                                child: Icon(
                                  Icons.remove_red_eye,
                                  color: _obscureText
                                      ? AppMidPurple
                                      : AppMediumGray,
                                ),
                                onTap: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(5.0)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: Container()),
//          Flexible(child: Container(), fit: FlexFit.loose,),
                    Container(
                      color: Colors.grey[100],
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                      child: RaisedButton(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        onPressed: _usernameController.text.isNotEmpty &&
                                _passwordController.text.isNotEmpty
                            ? () async {
                                try {
                                  /*await Provider.of<User>(context,
                                          listen: false)
                                      .attemptLogin(
                                          username: _usernameController.text,
                                          password: _passwordController.text);*/
//                                   Navigator.of(context)
//                                      .pushReplacementNamed('/home');

                                  runMutation(
                                    {
                                      "authData": {
                                        "email":
                                            _usernameController.text.toString(),
                                        "password":
                                            _passwordController.text.toString()
                                      },
                                    },
                                  );


                                  /*
                                  * "email": "ciadmin@c-ileasing.com",
                                        "password": "@1234psl"
                                  * */
                                } catch (e) {
                                  print(e);
                                }
                              }
                            : null,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                        child:
                            /*Provider.of<User>(context).loading
                            ? CircularProgressIndicator(
                                backgroundColor: Colors.white,
                              )
                            : Text(
                                'Login',
                                style: Theme.of(context)
                                    .textTheme
                                    .body1
                                    .copyWith(color: AppWhite),
                              ),*/
                            result.loading
                                ? CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                  )
                                : Text(
                                    'Login',
                                    style: Theme.of(context)
                                        .textTheme
                                        .body1
                                        .copyWith(color: AppWhite),
                                  ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCustomTextField(TextEditingController _controller) {
    return TextField(
      controller: _controller,
      style: Theme.of(context).textTheme.body1,
      decoration: InputDecoration(
        labelText: 'Company Email',
        suffixIcon: InkWell(
          child: Icon(
            Icons.cancel,
            color: AppMediumGray,
          ),
          onTap: () {
            _controller.clear();
          },
        ),
        border:
            OutlineInputBorder(borderRadius: new BorderRadius.circular(5.0)),
      ),
    );
  }
}
