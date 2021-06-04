import 'package:flutter/material.dart';
import 'package:pharmacy_manager/app_state.dart';
import 'package:pharmacy_manager/pages/login/authentication.dart';
import 'package:pharmacy_manager/utilities/widgets.dart';
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
            return ListView.builder(
              itemBuilder: (context, index) {
                return DrugCard(drug: appState.drugs[index]);
              },
              itemCount: appState.drugs.length,
            );

          case ApplicationLoginState.notKnown:
            return Center(child: CircularProgressIndicator());

          default:
            return Text("This Should Not happen");
        }
      }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Provider.of<ApplicationState>(context, listen: false).addDummyDrug();
        },
      ),
    );
  }
}
