import 'package:flutter/material.dart';

import './core/core.dart';

class AppStartup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Center(
        child: GradientBackround(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                child: Image.asset("assets/images/logo.png",
                    fit: BoxFit.cover, width: 200),
              ),
              SizedBox(height: 50),
              CircularProgressIndicator()
            ],
          ),
        ),
      ),
    );
  }
}
