import 'package:flutter/material.dart';
import 'package:pharmacy_manager/app_state.dart';
import 'package:pharmacy_manager/pages/login/authentication.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: Consumer<ApplicationState>(builder: (context, appState, child) {
        switch (appState.loginState) {
          case ApplicationLoginState.loggedIn:
            return Text('logged in');

          case ApplicationLoginState.notKnown:
            return Center(child: CircularProgressIndicator());

          default:
            return Text("This Should Not happen");
        }
      }),
    );
  }
}
