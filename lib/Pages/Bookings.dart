import 'dart:async';
import 'package:book_my_turf/Pages/turfDetails.dart';
import 'package:book_my_turf/main.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingPage extends StatefulWidget {
  final DocumentSnapshot document;
  BookingPage({@required this.document});

  @override
  _BookingPageState createState() => _BookingPageState(document: document);
}

class _BookingPageState extends State<BookingPage> {
  final DocumentSnapshot document;
  _BookingPageState({@required this.document});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: Text(
          "BookMyTurf",
          style: TextStyle(color: Colors.white, fontSize: 25.0),
        ),
        centerTitle: true,
        backgroundColor: Colors.green[700],
      ),
      body: ListView.builder(
        itemCount: document["Hours per day"],
        itemBuilder: (context, position) {
          return Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: RaisedButton(
                    child: Text((timings() + position).toString() +
                        document["Start Time"].toString().substring(2) +
                        " - " +
                        (timings() + position + 1).toString() +
                        document["Start Time"].toString().substring(2)),
                    onPressed: () {},
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: RaisedButton(
                    child: document["Booking"]
                                [(timings() + position + 1).toString()] ==
                            true
                        ? Text("Not Available")
                        : Text("Available"),
                     onPressed: () async {
                      if (document["Booking"]
                              [(timings() + position + 1).toString()] ==
                          false) {
                        var updatedTimings = new Map();
                        updatedTimings = document["Booking"];
                        updatedTimings[(timings() + position + 1).toString()] =
                            true;
                        print(updatedTimings);
                        await Firestore.instance
                            .collection("turfs")
                            .document(document["createdAt"])
                            .updateData({"Booking": updatedTimings});
                        this.setState(() {});
                      }
                    },
                    color: document["Booking"]
                                [(timings() + position + 1).toString()] ==
                            true
                        ? Colors.red
                        : Colors.green,
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  int timings() {
    int start = int.parse(document["Start Time"].toString().substring(0, 2));
    return start;
  }
}

// Widget createTable() {
//   List<TableRow> rows = [];
//   for (int i = 0; i < 100; ++i) {
//     rows.add(TableRow(children: [
//       Text("number " + i.toString()),
//       Text("squared " + (i * i).toString()),
//     ]));
//   }
//   return Table(children: rows);
// }
