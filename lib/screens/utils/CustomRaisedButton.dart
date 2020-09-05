import 'package:flutter/material.dart';
import 'package:inventory_app/utils/app_colors.dart';

class CustomRaisedButton extends StatelessWidget {
  final Function onTap;
  final String label;
  final ButtonType type;
  final EdgeInsetsGeometry padding;

  const CustomRaisedButton({
    Key key,
    @required this.onTap,
    @required this.label,
    this.type = ButtonType.LightPurple,
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      padding: padding,
      onPressed: onTap,
      color: type == ButtonType.LightPurple
          ? AppLightPurple
          : type == ButtonType.DeepPurple ? AppDeepPurple : AppDarkGreen,
      child: Text(
        label,
        style: TextStyle(
          color: type == ButtonType.LightPurple ? AppDeepPurple : AppWhite,
        ),
      ),
    );
  }
}

enum ButtonType { LightPurple, DeepGreen, DeepPurple }
