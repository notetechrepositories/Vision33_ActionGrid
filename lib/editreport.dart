import 'package:actiongrid/Utilities/Models/model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'constants.dart';
import 'package:intl/intl.dart';

class Editreport extends StatefulWidget {
  List<Headers> headers;
  Tabledata? orderData;
  String? title;
  Editreport(
      {super.key,
      required this.orderData,
      required this.title,
      required this.headers});

  @override
  State<Editreport> createState() => _EditreportState();
}

class _EditreportState extends State<Editreport> {
  Map<String, String> selectedData = {"": ""};
  TextEditingController dateController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    if (widget.headers != null) {
      for (Headers header in widget.headers) {
        Map dataMap = widget.orderData!.toJson();
        print(header.format!);
        selectedData[header.column!] = dataMap[header.column!];
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title!)),
        body: Stack(
          children: [
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 30, 30, 15),
                child: SingleChildScrollView(
                    child: Column(
                  children: _getListings(),
                )),
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            Positioned(
                bottom: 0,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 130,
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xFFaa0e3f),
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.0),
                            )),
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: TextButton(
                          child: Text(
                            "Update",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            print(selectedData);
                          },
                        ),
                      ),
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0)),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, -2),
                          blurRadius: 2,
                          spreadRadius: 0,
                          color: Colors.grey,
                        ),
                      ],
                    )))
          ],
        ));
  }

  List<Widget> _getListings() {
    List<Widget> listings = <Widget>[];

    for (int i = 0; i < widget.headers.length; i++) {
      if (widget.headers[i].column != "OrderID") {
        String value = selectedData[widget.headers[i].column!] ?? "";
        if (widget.headers[i].format == "string" &&
            widget.headers[i].dropdown! == false) {
          listings.add(getTextField(widget.headers[i].column!));
        } else if (widget.headers[i].format == "string" &&
            widget.headers[i].dropdown!) {
          listings.add(getDropdown(
              widget.headers[i].column!, widget.headers[i].values!));
        } else if (widget.headers[i].format == "date") {
          listings.add(getdateTextField(widget.headers[i].column!));
        }
        listings.add(
          const SizedBox(
            height: 15,
          ),
        );
      }
    }
    return listings;
  }

  Widget getDropdown(String field, List<String> values) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: Color(0xFF047CB7), width: 0.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(
              color: Color(0xFF047CB7),
            ),
          ),
          hintStyle: TextStyle(color: Color(0xFF047CB7)),
          filled: true,
          fillColor: Colors.white,
          counterText: "",
          labelText: field,
          labelStyle: TextStyle(color: Color(0xFF047CB7)),
          hintText: field),
      value: values[0],
      items: values.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (val) {
        setState(
          () {
            selectedData[field] = val!;
          },
        );
      },
    );
  }

  Widget getTextField(String field) {
    return TextFormField(
      initialValue: selectedData[field],
      onChanged: (text) {
        selectedData[field] = text;
      },
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: Color(0xFF047CB7), width: 0.0),
          ),
          hintText: field,
          labelText: field),
    );
  }

  DateTime dateTime = DateTime.now();
  _selectDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: dateTime,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null) {
      dateTime = picked;
      //assign the chosen date to the controller
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String formatted = formatter.format(dateTime);
      dateController.text = formatted;
    }
  }

  Widget getdateTextField(String field) {
    dateController.text = selectedData[field] ?? "";
    return TextFormField(
      onTap: _selectDate,
      controller: dateController,
      onChanged: (text) {
        selectedData[field] = text;
      },
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: Color(0xFF047CB7), width: 0.0),
          ),
          hintText: field,
          labelText: field),
    );
  }
}
