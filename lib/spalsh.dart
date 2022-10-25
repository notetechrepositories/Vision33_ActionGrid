import 'package:actiongrid/home.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  static final valueKey = ValueKey('Splash');

  @override
  State<StatefulWidget> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  void initState() {
    super.initState();
    Future.delayed(
        const Duration(seconds: 3),
        () => {
              //   Navigator.push(context, MaterialPageRoute(builder: (_) => Home()))
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => Home()))
            });
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
      child: Container(
        width: MediaQuery.of(context).size.height * 0.2,
        height: MediaQuery.of(context).size.height * 0.2,
        child: Image.asset(
          'assets/images/logo.png',
        ),
      ),
    );
  }
}
