import 'package:HelpNow/model/database.dart';
import 'package:HelpNow/model/element.dart' as el;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class elementList with ChangeNotifier {
  List<el.Element> items = [];

  //Add element into items and into db
  void addElementinDB(el.Element e) {
    items.add(e);
    notifyListeners();
    DB.insertUserDate(e.toJson(), e.date);
    Fluttertoast.showToast(msg: 'Added details');
  }

  //Fetching the items from the local storage
  Future<List<el.Element>> fetchElements() async {
    dynamic dd = await DB.getElements();
    List<el.Element> ans = [];
    for (dynamic val in dd) {
      ans.add(el.Element.fromJson(val['jsonData']));
    }
    print('****** $ans *********');
    this.items = ans;
    notifyListeners();
    return ans;
  }

  //Fetching elements for export from time a to b
  Future<dynamic> fetchElementsinTime(DateTime from, DateTime to) async {
    dynamic dd = await DB.searchElements(
      from,
      to.add(
        Duration(days: 1),
      ),
    );

    List<List<dynamic>> ans = [
      ["Name", "Amount", "Mobile", "Amount Type", "Product Type", "Date"]
    ];
    for (dynamic val in dd) {
      el.Element ee = el.Element.fromJson(val['jsonData']);
      List<dynamic> ll = [];
      ll.add(ee.name);
      ll.add(ee.amount);
      ll.add(ee.mobile);
      ll.add(ee.amountType);
      ll.add(ee.productType);
      ll.add(ee.date.toIso8601String());
      ans.add(ll);
    }
    print('****** $ans  $dd *********');
    return ans;
  }
}
