import 'package:actiongrid/Utilities/Models/model.dart';
import 'package:flutter/material.dart';

class Editreport extends StatefulWidget {
  String? title;
  Editreport({super.key, required this.title});

  @override
  State<Editreport> createState() => _EditreportState();
}

class _EditreportState extends State<Editreport> {
  Map<String, dynamic>? selectedData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title!)),
        body: Stack(
          children: [
            Container(
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
                          onPressed: () {},
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
    listings.add(getTextField("Order ID"));
    listings.add(
      const SizedBox(
        height: 15,
      ),
    );

    listings.add(getDropdown("Order Date"));
    listings.add(
      const SizedBox(
        height: 15,
      ),
    );
    listings.add(getdateTextField("Order Date"));
    return listings;
  }

  Widget getDropdown(String field) {
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
      value: field,
      items:
          ["Order Date", "hai"].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (val) {
        setState(
          () {},
        );
      },
    );
  }
  // List<Widget> _getListings(List<Headers>? header) {
  //   List<Widget> listings = <Widget>[];
  //   listings.add(getTextField("Order ID"));
  //   if (header != null && header.isNotEmpty) {
  //     int i = 0;
  //     for (i = 0; i < header.length; i++) {
  //       if (header[i].format == "string" && header[i].dropdown!) {
  //       } else if (header[i].format == "string" && header[i].dropdown!) {}

  //       listings.add(
  //         const SizedBox(
  //           height: 12,
  //         ),
  //       );
  //     }
  //   }
  //   if (listings.isNotEmpty) {
  //     listings.add(
  //       const SizedBox(
  //         height: 12,
  //       ),
  //     );
  //   }
  //   return listings;
  // }

  Widget getTextField(String field) {
    return TextFormField(
      initialValue: field,
      onChanged: (text) {},
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

    }
  }

  Widget getdateTextField(String field) {
    return TextFormField(
      initialValue: field,
      onTap: _selectDate,
      onChanged: (text) {},
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: Color(0xFF047CB7), width: 0.0),
          ),
          hintText: field,
          labelText: field),
    );
  }
}
