import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:inventory_app/models/ReturnReason.dart';
import 'package:inventory_app/screens/outbound/ReturnToVendorScanScreen.dart';
import 'package:inventory_app/screens/utils/ClearableTextField.dart';
import 'package:inventory_app/utils/app_colors.dart';

class VendorReturnScreen extends StatefulWidget {
  @override
  _VendorReturnScreenState createState() => _VendorReturnScreenState();
}

class _VendorReturnScreenState extends State<VendorReturnScreen> {
  String chosenType = "0";
  final poIdController = TextEditingController();

  final List<POItem> poList = [];
  String chosenReason = "20001";

  bool tileIsOpen = false;
  bool buttonSubmitted = false;

  final reasons = <ReturnReason>[
    ReturnReason('20001', 'Damaged Goods'),
    ReturnReason('20004', 'Incomplete Packaging'),
    ReturnReason('20009', 'Seal Broken')
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Return to Vendor'),
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
                      Text('Return to Vendor',
                          style: Theme.of(context).textTheme.title),
                      SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .8,
                        child: Text(
                            "To return goods to vendor kindly enter the goods return number",
                            style: Theme.of(context).textTheme.body1),
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Radio(
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  activeColor: AppMidPurple,
                                  value: '0',
                                  groupValue: chosenType,
                                  onChanged: (value) {
                                    setState(() {
                                      chosenType = value;
                                    });
                                  },
                                ),
                                Text(
                                  'C&I Property',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Radio(
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  activeColor: AppMidPurple,
                                  value: '1',
                                  groupValue: chosenType,
                                  onChanged: (value) {
                                    setState(() {
                                      chosenType = value;
                                    });
                                  },
                                ),
                                Text(
                                  'Consignment',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * .82,
                          child: ClearableTextField(
                            textEditingController: poIdController,
                            label: "Goods Return Number",
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * .82,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[500]),
                                borderRadius: BorderRadius.circular(3)),
                            child: DropdownButton(
                              isExpanded: true,
                              value: chosenReason,
                              icon: Icon(Icons.keyboard_arrow_down),
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black54),
                              hint: Text('Select a reason for return'),
                              underline: Container(),
                              items: reasons
                                  .map(
                                    (r) => DropdownMenuItem(
                                      child:
                                          Text('${r.reasonCode} - ${r.title}'),
                                      value: r.reasonCode,
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                print(value);
                                setState(() {
                                  chosenReason = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3)),
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            onPressed: () {
                              setState(() {
                                poList.clear();
                                poList.addAll([
                                  POItem("A00001", "Google Chromecast"),
                                  POItem("A00001", "Google Chromecast"),
                                  POItem("A00001", "Google Chromecast"),
                                ]);
                              });
                            },
                            child: Text(
                              'Submit',
                              style: Theme.of(context)
                                  .textTheme
                                  .body1
                                  .copyWith(color: AppWhite),
                            ),
                          ),
                        ),
                      ),
                      AnimatedOpacity(
                        opacity: poList.length > 0 ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 300),
                        child: Center(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Color(0xFFC7F6E2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 50),
                            child: Text(
                              "Location ID: 12345SDF12SK",
                              style: TextStyle(
                                  color: Color(0xFF146A58), fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(color: Colors.grey[300]),
                          color: poList.length > 0
                              ? tileIsOpen ? Color(0xFF839AB0) : Colors.white
                              : Colors.grey[300],
                        ),
                        child: ExpansionTile(
                          title: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('${poList.length} items in GRN',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            tileIsOpen ? Colors.white : null)),
                                Text('View',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            tileIsOpen ? Colors.white : null)),
                              ],
                            ),
                          ),
                          children: _buildPoItems(poList),
                          onExpansionChanged: (isOpen) {
                            setState(() {
                              tileIsOpen = isOpen;
                            });
                          },
                        ),
                      ),
//                    SizedBox(height: MediaQuery.of(context).size.height * .1),
                    ],
                  ),
                ),
//              Expanded(child: Container()),
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
            onPressed: poList.length > 0
                ? () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => VendorReturnScanScreen(
                              locationID: "12345SDF12SK",
                            )));
                  }
                : null,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            child: Text(
              'Start Scan',
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
