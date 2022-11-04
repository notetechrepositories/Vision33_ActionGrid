// ignore: implementation_imports
import 'package:actiongrid/editreport.dart';
import 'package:actiongrid/reportpage.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _submitfieldControler = TextEditingController();
  bool error = false;
  @override
  void initState() {
    print("init");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFaa0e3f),
        onPressed: () {
          howDataAlert();
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Salt Box "),
      ),
      body: Container(
        color: const Color(0xFFD3D3D3),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => Editreport(
                                    title: "Report name",
                                  )));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      color: Colors.white,
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(3, 5, 3, 5),
                        child: ListTile(
                          title: Text(
                            "Report name",
                            style: TextStyle(
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
                itemCount: 10),
          ),
        ),
      ),
    );
  }

  howDataAlert() {
    error = false;
    _submitfieldControler.text = "";
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    20.0,
                  ),
                ),
              ),
              contentPadding: const EdgeInsets.only(
                top: 10.0,
              ),
              title: const Text(
                "Create Report",
                style: TextStyle(fontSize: 24.0, color: Color(0xFFaa0e3f)),
              ),
              content: SizedBox(
                height: 220,
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
                          decoration: InputDecoration(
                              errorText:
                                  error ? "Please enter report name" : null,
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 0.0),
                              ),
                              border: const OutlineInputBorder(),
                              hintText: 'Enter name here',
                              labelText: 'Name'),
                        ),
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
                              Navigator.of(context).pop();
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
                    ],
                  ),
                ),
              ),
            );
          }));
        });
  }
}
