import 'dart:convert';

import 'package:HelpNow/model/database.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Element {
  String name;
  String mobile;
  int amount;
  String amountType;
  String productType;
  String photoUrl;
  DateTime date;

  Element({this.photoUrl,
    this.date,
    this.productType,
    this.amountType,
    this.amount,
    this.mobile,
    this.name});

  String toJson() {
    return json.encode({
      'name': this.name,
      'mobile': this.mobile,
      'amount': this.amount,
      'amountType': this.amountType,
      'productType': this.productType,
      'date': this.date.toString(),
      'photoUrl': this.photoUrl
    });
  }


  static Element fromJson(String details) {
    Map<dynamic, dynamic> map = json.decode(details);
    return Element(
        name: map['name'],
        amount: map['amount'],
        amountType: map['amountType'],
        date: DateTime.parse(map['date']),
        mobile: map['mobile'],
        photoUrl: map['photoUrl'],
        productType: map['productType']);
  }


}
