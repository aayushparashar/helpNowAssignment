import 'dart:io';

import 'package:HelpNow/model/element.dart' as el;
import 'package:HelpNow/model/providerList.dart';
import 'package:HelpNow/screens/addDetailsScreen.dart';
import 'package:HelpNow/widgets/exportWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  List<String> dummyData;

  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> isDialOpen = ValueNotifier(false);
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(title: Text('Home Screen')),
          floatingActionButton: SpeedDial(
            /// both default to 16
            marginEnd: 18,
            marginBottom: 20,
            icon: Icons.add,
            activeIcon: Icons.remove,
            buttonSize: 56.0,
            visible: true,
            closeManually: false,
            renderOverlay: false,
            curve: Curves.bounceIn,
            overlayColor: Colors.black,
            overlayOpacity: 0.5,
            onOpen: () => print('OPENING DIAL'),
            onClose: () => print('DIAL CLOSED'),
            tooltip: 'Speed Dial',
            heroTag: 'speed-dial-hero-tag',
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 8.0,
            shape: CircleBorder(),
            openCloseDial: isDialOpen,
            children: [
              SpeedDialChild(
                child: Icon(Icons.share),
                backgroundColor: Colors.white,
                label: 'Export',
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: () {
//                    showDialog(context: context, builder: (ctx) => exportWidget());
                  showModalBottomSheet(
                      context: context, builder: (ctx) => exportWidget());
                },
              ),
              SpeedDialChild(
                child: Icon(Icons.add),
                backgroundColor: Colors.white,
                label: 'Add',
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: () =>
                    Navigator.of(context).pushNamed(AddDetailsScreen.routeName),
              ),
            ],
          ),
          body: FutureBuilder(
              future: Provider.of<elementList>(context, listen: false)
                  .fetchElements(),
              builder: (ctx, snap) {
                if (snap.connectionState == ConnectionState.waiting)
                  return Center(
                    child: CircularProgressIndicator(),
                  );

                return Consumer<elementList>(builder: (context, val, __) {
                  List<el.Element> elements = val.items;
                  if (elements.length == 0) {
                    return Center(
                      child: Text(
                        'No items added',
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: elements.length,
                    itemBuilder: (context, i) => new Column(
                      children: <Widget>[
                        new Divider(
                          height: 10.0,
                        ),
                        new ListTile(
                          leading: elements[i].photoUrl != null
                              ? CircleAvatar(
                                  backgroundImage:
                                      FileImage(File(elements[i].photoUrl)),
                                )
                              : new CircleAvatar(
                                  foregroundColor:
                                      Theme.of(context).primaryColor,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.black,
                                  ),
//              backgroundImage: new NetworkImage(dummyData[i].avatarUrl),
                                ),
                          title: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              new Text(
                                '${elements[i].name} ${elements[i].mobile}',
                                style:
                                    new TextStyle(fontWeight: FontWeight.bold),
                              ),
                              new Text(
                                '₹${elements[i].amount}',
                                style: new TextStyle(
                                    color: Colors.grey, fontSize: 14.0),
                              ),
                            ],
                          ),
                          subtitle: new Container(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: new Text(
                              DateFormat('dd MMM yyyy')
                                  .format(elements[i].date)
                                  .toString(),
                              style: new TextStyle(
                                  color: Colors.grey, fontSize: 15.0),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                });
              }),
        ),
        onWillPop: () async {
          if (isDialOpen.value) {
            isDialOpen.value = false;
            return false;
          }
          return true;
        });
  }
}
