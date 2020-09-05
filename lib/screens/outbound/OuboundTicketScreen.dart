import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:inventory_app/screens/utils/ClearableTextField.dart';
import 'package:inventory_app/screens/utils/ExpandableListItem.dart';
import 'package:inventory_app/screens/utils/ScreenActionButton.dart';
import 'package:inventory_app/utils/app_colors.dart';

class OutboundTicketScreen extends StatefulWidget {
  @override
  _OutboundTicketScreenState createState() => _OutboundTicketScreenState();
}

class _OutboundTicketScreenState extends State<OutboundTicketScreen> {
  final poIdController = TextEditingController();

  final List<POItem> poList = [];

  bool tileIsOpen = false;
  var locationID = '1249ABCDS12K';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Outbound - Pick Ticket ID'),
        ),
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 80),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Pick Ticket ID',
                          style: Theme.of(context).textTheme.title),
                      SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .8,
                        child: Text(
                            "To carry out the outbound process please enter the pick ticket ID",
                            style: Theme.of(context).textTheme.body1),
                      ),
                      SizedBox(height: 30),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * .82,
                          child: ClearableTextField(
                            textEditingController: poIdController,
                            label: "Pick Ticket ID",
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 30),
                        child: Center(
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3)),
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            onPressed: () {
                              setState(() {
                                tileIsOpen = !tileIsOpen;
                              });
                              print(tileIsOpen);
                            },
                            child: Text(
                              'Submit ID',
                              style: Theme.of(context)
                                  .textTheme
                                  .body1
                                  .copyWith(color: AppWhite),
                            ),
                          ),
                        ),
                      ),
                      AnimatedOpacity(
                        opacity: tileIsOpen ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 300),
                        child: Column(
                          children: <Widget>[
                            Text(
                              '3 items in ticket',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFC7F6E2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 5),
                              child: Text(
                                "Items Location ID: $locationID",
                                style: TextStyle(
                                    color: Color(0xFF146A58), fontSize: 14),
                              ),
                            ),
                            SizedBox(height: 20),
                            ListView.separated(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, int) =>
                                    ExpandableListItem(),
                                separatorBuilder: (c, i) {
                                  return SizedBox(
                                    height: 20,
                                  );
                                },
                                itemCount: 3)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.grey[100],
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: RaisedButton(
            padding: EdgeInsets.symmetric(vertical: 16),
            elevation: 0,
            color: AppDarkGreen,
            onPressed: tileIsOpen ? () {
              Navigator.of(context).pushNamed('/outbound-location-scan');
            } : null,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            child: Text(
              'Proceed to pick items',
              style:
                  Theme.of(context).textTheme.body1.copyWith(color: AppWhite),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPoItems(List<POItem> items) {
    return items
        .map((f) => Container(
              decoration: BoxDecoration(
                  color: AppWhite,
                  border: Border(bottom: BorderSide(color: AppMediumGray))),
              child: ListTile(
                title: Text(
                  f.ID,
                  style:
                      Theme.of(context).textTheme.body2.copyWith(fontSize: 15),
                ),
                subtitle: Text(
                  f.title,
                  style: Theme.of(context).textTheme.body1,
                ),
              ),
            ))
        .toList();
  }
}

class POItem {
  final String ID;
  final String title;

  POItem(this.ID, this.title);
}
