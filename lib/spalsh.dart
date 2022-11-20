import 'package:actiongrid/Utilities/Internetcheck.dart';
import 'package:actiongrid/Utilities/Models/model.dart';
import 'package:actiongrid/constants.dart';
import 'package:actiongrid/home.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Utilities/shared_preference_util.dart';

class Splash extends StatefulWidget {
  static final valueKey = ValueKey('Splash');

  @override
  State<StatefulWidget> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool _isLoading = false;
  void initState() {
    super.initState();
    configuration();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ui(),
    );
  }

  Widget ui() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.height * 0.2,
            height: MediaQuery.of(context).size.height * 0.2,
            child: Image.asset(
              'assests/images/Saltbox_icon.png',
            ),
          ),
          const SizedBox(
            height: 100,
          ),
          Visibility(
            visible: _isLoading,
            child: const CircularProgressIndicator(
              color: Color(0xFF047CB7),
            ),
          )
        ],
      ),
    );
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
  configuration() async {
    Utils.checkInternetConnection().then((connectionResult) async {
      if (connectionResult) {
        setState(() {
          _isLoading = true;
        });

        String url = Constants.base_url + 'report_config';

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
          print(parsed);

          Preference.setStringItem(Constants.column_data, json.encode(parsed));
          List headers = parsed.map((job) => Headers.fromJson(job)).toList();
          print(headers);
          Future.delayed(const Duration(milliseconds: 500), () {
            setState(() {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => const Home()));
            });
          });
        } else {
          _showToast("Host Unreachable, try again later");
        }
      } else {
        _showToast("No internet connection available");
      }
    });
  }
}
