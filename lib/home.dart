// ignore: implementation_imports

import 'package:actiongrid/Utilities/Internetcheck.dart';
import 'package:actiongrid/editreport.dart';
import 'package:actiongrid/reportpage.dart';

import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Utilities/Models/model.dart';
import 'Utilities/shared_preference_util.dart';
import 'constants.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isLoading = false;
  bool _isapply = false;
  bool _nodata = false;
  String _selecteConnection = "Connection 1";
  List<Reports> reports = [];
  final _submitfieldControler = TextEditingController();
  bool error = false;

  @override
  void initState() {
    super.initState();
    //getreportlist();
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        print("View will appear");
        getreportlist();
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFFaa0e3f),
          onPressed: () {
            howDataAlert();
          },
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Image.asset(
            "assests/images/Saltbox_title.png",
            height: 50,
            width: 100,
            fit: BoxFit.contain,
          ),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFaa0e3f),
                ),
              )
            : Container(
                color: const Color(0xFFD3D3D3),
                height: MediaQuery.of(context).size.height,
                child: _nodata
                    ? const Center(child: Text("No reports found"))
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: ListView.separated(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Future<String> accesspoint =
                                        Preference.getStringItem(
                                            Constants.column_data);
                                    accesspoint.then((data) async {
                                      if (data.isNotEmpty) {
                                        List columns = json.decode(data);
                                        List<Headers> headers = columns
                                            .map((job) => Headers.fromJson(job))
                                            .toList();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => Reportpage(
                                                      title: reports[index]
                                                          .reportName,
                                                      id: reports[index]
                                                          .id
                                                          .toString(),
                                                      headers: headers,
                                                      databaseid: reports[index]
                                                          .databaseID,
                                                    )));
                                      }
                                    }, onError: (e) {});
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    color: Colors.white,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(3, 5, 3, 5),
                                      child: ListTile(
                                        trailing: InkWell(
                                            onTap: () {
                                              deleteData(
                                                  reports[index].id.toString(),
                                                  reports[index].databaseID!);
                                            },
                                            child: Icon(Icons.delete)),
                                        title: Text(
                                          reports[index].reportName ?? "",
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const Divider(
                                  height: 5,
                                  color: Colors.transparent,
                                );
                              },
                              itemCount: reports.length),
                        ),
                      ),
              ),
      ),
    );
  }

  howDataAlert() {
    error = false;
    _submitfieldControler.text = "";
    final FocusNode unitCodeCtrlFocusNode = FocusNode();
    unitCodeCtrlFocusNode.requestFocus();
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              scrollable: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    20.0,
                  ),
                ),
              ),
              contentPadding: const EdgeInsets.only(left: 20.0,right: 20.0,top: 20.0,
              ),
              title: const Center(
                child: Text(
                  "Create Report",
                  style: TextStyle(fontSize: 24.0, color: Color(0xFFaa0e3f)),
                ),
              ),
              content: SizedBox(
                height: 330,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Mention Your Report name",
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _submitfieldControler,
                          onChanged: (text) {
                            if (text.isNotEmpty) {
                              setState(() {
                                error = false;
                              });
                            }
                          },
                          focusNode: unitCodeCtrlFocusNode,
                          decoration: InputDecoration(
                              errorText:
                                  error ? "Please enter report name" : null,
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1.0),
                              ),
                              border: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1.0),
                              ),
                              hintText: 'Enter name here',
                              labelText: 'Name'),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 0.0),
                              ),
                              focusedBorder: const OutlineInputBorder(),
                              hintStyle: TextStyle(color: Color(0xFF047CB7)),
                              filled: true,
                              fillColor: Colors.white,
                              counterText: "",
                              labelText: "",
                              labelStyle: TextStyle(color: Color(0xFF047CB7)),
                              hintText: "field"),
                          value: _selecteConnection,
                          items: [
                            "Connection 1",
                            "Connection 2",
                            "Connection 3"
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(
                              () {
                                _selecteConnection = val!;
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        height: 60,
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_submitfieldControler.text.isEmpty) {
                              setState(() {
                                print("true");
                                error = true;
                              });
                            } else {
                              setState(() {
                                if (!_selecteConnection.isEmpty) {
                                  String connection = "1";
                                  if (_selecteConnection == "Connection 1") {
                                    connection = "1";
                                  } else if (_selecteConnection ==
                                      "Connection 2") {
                                    connection = "2";
                                  }
                                  if (_selecteConnection == "Connection 3") {
                                    connection = "3";
                                  }
                                  setState(() {
                                    createReport(_submitfieldControler.text,
                                        connection, context);
                                  });
                                }
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFF047CB7),
                          ),
                          child: const Text("Submit",
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Visibility(
                        visible: _isapply,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF047CB7),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }));
        });
  }

  void _showToast(String msg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 2000),
        content: Text(msg),
      ),
    );
  }

  //Api
  getreportlist() async {
    Utils.checkInternetConnection().then((connectionResult) async {
      if (connectionResult) {
        setState(() {
          _isLoading = true;
        });

        String url = Constants.base_url + 'report_list';

        var uri = Uri.parse(url);

        final response = await http.get(
          uri,
          headers: <String, String>{
            'Content-Type': "application/json",
          },
        );
        setState(() {
          _isLoading = false;
        });
        if (response.statusCode == 200) {
          List parsed = json.decode(response.body);
          reports = parsed.map((job) => Reports.fromJson(job)).toList();
          if (reports.length == 0) {
            _nodata = true;
          } else {
            _nodata = false;
          }
        } else {
          _showToast("Host Unreachable, try again later");
        }
      } else {
        _showToast("No internet connection available");
      }
    });
  }

  deleteData(String reportID, String databaseID) async {
    Utils.checkInternetConnection().then((connectionResult) async {
      if (connectionResult) {
        setState(() {
          _isLoading = true;
        });

        String url =
            Constants.base_url + 'data/delete/${reportID}?dbNo=${databaseID}';

        var uri = Uri.parse(url);

        final response = await http.delete(
          uri,
          headers: <String, String>{
            'Content-Type': "application/json",
          },
        );

        if (response.statusCode == 200) {
          _showToast("Deleted Successfully");
          getreportlist();
        } else {
          _showToast("Host Unreachable, try again later");
        }
      } else {
        _showToast("No internet connection available");
      }
    });
  }

  createReport(
      String reportname, String connection, BuildContext context) async {
    Utils.checkInternetConnection().then((connectionResult) async {
      if (connectionResult) {
        setState(() {
          _isapply = true;
        });

        String url =
            Constants.base_url + 'create_report/add_new?dbNo=${connection}';

        var uri = Uri.parse(url);
        Map report = {"reportName": reportname};
        var body = jsonEncode(report);
        final response = await http.post(uri,
            headers: <String, String>{
              'Content-Type': "application/json",
            },
            body: body);
        setState(() {});

        if (response.statusCode == 201) {
          _showToast("Report created successfully");

          Future.delayed(const Duration(milliseconds: 500), () {
            _isapply = false;
            setState(() {
              Navigator.of(context).pop();
            });
          });
          getreportlist();
        } else {
          _showToast("Host Unreachable, try again later");
        }
      } else {
        _showToast("No internet connection available");
      }
    });
  }
}
