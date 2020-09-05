import 'package:flutter/material.dart';
import 'package:inventory_app/utils/app_colors.dart';

class ScreenActionButton extends StatefulWidget {
  final Function onPressed;
  final String text;
  final bool enabled;

  const ScreenActionButton(
      {Key key, @required this.onPressed, @required this.text, this.enabled})
      : super(key: key);
  @override
  _ScreenActionButtonState createState() =>
      _ScreenActionButtonState(onPressed, text, enabled);
}

class _ScreenActionButtonState extends State<ScreenActionButton> {
  final Function onPressed;
  final String text;
  final bool enabled;

  _ScreenActionButtonState(this.onPressed, this.text, this.enabled);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      child: RaisedButton(
        padding: EdgeInsets.symmetric(vertical: 16),
        elevation: 0,
        color: AppDarkGreen,
        onPressed: enabled ? onPressed : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        child: Text(
          text,
          style: Theme.of(context).textTheme.body1.copyWith(color: AppWhite),
        ),
      ),
    );
  }
}
