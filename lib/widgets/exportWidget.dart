import 'dart:io';

import 'package:HelpNow/model/providerList.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:HelpNow/model/element.dart' as el;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:simple_permissions/simple_permissions.dart';

class exportWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _exportState();
  }
}

class _exportState extends State<exportWidget> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      bottomNavigationBar: Builder(
        builder: (context) => MaterialButton(
          onPressed: () async {
            dynamic data =
                await Provider.of<elementList>(context, listen: false).fetchElementsinTime(fromDate, toDate);
            await SimplePermissions.requestPermission(
                Permission.WriteExternalStorage);
            bool checkPermission = await SimplePermissions.checkPermission(
                Permission.WriteExternalStorage);
            if (checkPermission) {
              String dir = (await getExternalStorageDirectory()).absolute.path +
                  "/documents";
              String file = "$dir";
              print(" FILE " + file);
              File f = new File(file + "${DateTime.now().toString()}.csv");
              String csv = const ListToCsvConverter().convert(data);

              await f.writeAsString(csv);
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Added csv file to ${f.path}'),
              ),);
              OpenFile.open(f.path,
                type: "application/vnd.ms-excel",
                uti: "com.microsoft.excel.xls",);

              print('** ${csv} &&&');
            }
          },
          color: Colors.redAccent,
          minWidth: double.maxFinite,
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Text(
            'Export Details',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: Container(
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "FROM",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "${fromDate.toLocal()}".split(' ')[0],
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              onPressed: () => _selectDate(context, true), // Refer step 3
              child: Text(
                'Select date',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              color: Colors.redAccent,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "TO",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "${toDate.toLocal()}".split(' ')[0],
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              onPressed: () => _selectDate(context, false), // Refer step 3
              child: Text(
                'Select date',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              color: Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }

  _selectDate(BuildContext context, bool from) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: from ? fromDate : toDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );
    if (picked != null && picked != (from ? fromDate : toDate))
      setState(() {
        if (from)
          fromDate = picked;
        else
          toDate = picked;
      });
  }
}
