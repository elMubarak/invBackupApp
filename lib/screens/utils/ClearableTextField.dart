import 'package:flutter/material.dart';
import 'package:inventory_app/utils/app_colors.dart';

class ClearableTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String label;

  const ClearableTextField({
    Key key,
    @required this.textEditingController,
    @required this.label,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      style: Theme.of(context).textTheme.body1,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: InkWell(
          child: Icon(
            Icons.cancel,
            color: AppMediumGray,
          ),
          onTap: () {
            textEditingController.clear();
          },
        ),
        border: OutlineInputBorder(
          borderRadius: new BorderRadius.circular(5.0),
        ),
      ),
    );
  }
}
