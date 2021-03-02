import 'dart:convert';
import 'dart:io';

import 'package:HelpNow/model/element.dart' as el;
import 'package:HelpNow/model/providerList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddDetailsScreen extends StatefulWidget {
  static String routeName = '/addDetails';

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _addState();
  }
}

class _addState extends State<AddDetailsScreen> {
  File _image;
  final picker = ImagePicker();
  ImageSource source;
  Map<String, dynamic> details = {
    "name": "",
    "mobile": "",
    "amountType": "",
    "paymentType": "",
    "date": "",
    "amount": "",
    'photoUrl':"",
  };

  Future getImage() async {
    await showDialog(
        context: context,
        builder: (ctx) => SimpleDialog(
              children: [
                IconButton(
                    icon: Icon(Icons.camera_enhance),
                    onPressed: () {
                      setState(() {
                        source = ImageSource.camera;
                      });
                      Navigator.of(ctx).pop();
                    }),
                IconButton(
                    icon: Icon(Icons.camera),
                    onPressed: () {
                      setState(() {
                        source = ImageSource.gallery;
                      });
                      Navigator.of(ctx).pop();
                    }),
              ],
            ));

    final pickedFile = await picker.getImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  String _verticalGroupValue = '';

  String _verticalGroupValue2 = '';
  DateTime selectedDate = DateTime.now();
  GlobalKey<FormState> _form = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      bottomNavigationBar: Builder(
        builder: (context) => MaterialButton(
          onPressed: () async {
            if (_verticalGroupValue == "") {
              Fluttertoast.showToast(msg: "Please select a Product type");
            } else if (_image == null) {
              Fluttertoast.showToast(msg: "Please select an image");
            } else if (_verticalGroupValue2 == '') {
              Fluttertoast.showToast(msg: "Please select an Amount type");
            } else if (_form.currentState.validate()) {
              _form.currentState.save();
              details['amountType'] = _verticalGroupValue2;
              details['productType'] = _verticalGroupValue;
              details['date'] = selectedDate.toString();
              details['photoUrl'] = _image.path;
              el.Element e = el.Element.fromJson(json.encode(details));
              Provider.of<elementList>(context, listen: false).addElementinDB(e);
              Navigator.of(context).pop();
//              el.Element.addElementinDB(e);
            }
          },
          color: Colors.redAccent,
          minWidth: double.maxFinite,
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Text(
            'Save Details',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text('New Entry'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  child: CircleAvatar(
                    backgroundImage: _image == null ? null : FileImage(_image),
                    radius: 100,
                    backgroundColor: Colors.grey.withOpacity(0.1),
                    child: _image == null
                        ? Icon(
                            Icons.camera_alt,
                            color: Colors.black,
                            size: 50,
                          )
                        : null,
                  ),
                  onTap: getImage,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (val) {
                    if (val.length == 0) return "Please Enter a Name";
                    return null;
                  },
                  onSaved: (val) {
//                    if(val.length!=0)
                    details['name'] = val;
//                    else
//                    return "Please Enter a Name";
                  },
                  decoration: InputDecoration(
                    hintText: 'Name',
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (val) {
                    if (val.length == 0)
                      return "Please Enter a valid Mobile Number";
                    return null;
                  },
                  onSaved: (val) {
                    details['mobile'] = val;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      prefix: Text('+91'),
                      hintText: 'Phone Number',
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                RadioGroup<String>.builder(
                  horizontalAlignment: MainAxisAlignment.start,
                  direction: Axis.horizontal,
                  groupValue: _verticalGroupValue,
                  onChanged: (value) => setState(() {
                    _verticalGroupValue = value;
                  }),
                  items: ["Product", "Service"],
                  itemBuilder: (item) => RadioButtonBuilder(
                    item,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (val) {
                    if (val.length == 0) return "Please Enter a Amount";
                    return null;
                  },
                  onSaved: (val) {
//                    if(val.length!=0)
                    details['amount'] = int.parse(val);
//                    else
//                    return "Please Enter a Name";
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      prefixText: '₹',
                      hintText: 'Amount',
                      labelText: 'Amount',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                RadioGroup<String>.builder(
                  direction: Axis.horizontal,
                  groupValue: _verticalGroupValue2,
                  onChanged: (value) => setState(() {
                    _verticalGroupValue2 = value;
                  }),
                  items: ["GPay", "Cash", "Online"],
                  itemBuilder: (item) => RadioButtonBuilder(
                    item,
                  ),
                ),

                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RaisedButton(
                      onPressed: () => _selectDate(context), // Refer step 3
                      child: Text(
                        'Select date',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      color: Colors.redAccent,
                    ),
                    Text(
                      "${selectedDate.toLocal()}".split(' ')[0],
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                )
//              DropdownButton<String>(
//                value: dropdownValue,
//                icon: Icon(Icons.arrow_downward),
//                iconSize: 24,
//                elevation: 16,
//                style: TextStyle(color: Colors.deepPurple),
//                underline: Container(
//                  height: 2,
//                  color: Colors.deepPurpleAccent,
//                ),
//                onChanged: (String newValue) {
//                  setState(() {
//                    dropdownValue = newValue;
//                  });
//                },
//                items: <String>['One', 'Two', 'Free', 'Four']
//                    .map<DropdownMenuItem<String>>((String value) {
//                  return DropdownMenuItem<String>(
//                    value: value,
//                    child: Text(value),
//                  );
//                }).toList(),
//              ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }
}
