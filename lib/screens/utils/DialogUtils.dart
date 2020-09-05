import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final List<TextSpan> body;
  final List<Widget> actions;

  const CustomDialog({Key key, @required this.body, @required this.actions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8),
                decoration: ShapeDecoration(
                    shape: CircleBorder(), color: Color(0xFFE6E6FE)),
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(
                    Icons.cancel,
                    color: Color(0xFF4E47F3),
                  ),
                ),
              )
            ],
          ),
          RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 16, height: 1.8),
              children: body,
            ),
          ),
        ],
      ),
      actions: actions,
    );
  }
}

class DialogUtils {
  static void showCustomDialog({
    BuildContext context,
    List<TextSpan> dialogBody,
    List<Widget> actions,
  }) {
    showGeneralDialog(
      context: context,
      transitionDuration: Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (context, animation1, animation2) {
        return Container();
      },
      transitionBuilder: (context, anim1, anim2, widget) {
        return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(anim1),
            child: CustomDialog(
              body: dialogBody,
              actions: actions,
            ));
      },
    );
  }
}
