 import 'package:flutter/material.dart';
import 'package:pharmacy_manager/app_state.dart';
import 'package:pharmacy_manager/pages/qr/qr_screen.dart';
import 'package:pharmacy_manager/utilities/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pharmacy_manager/utilities/enums.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              switch (value) {
                case 'Logout':
                  Provider.of<ApplicationState>(context,listen: false).signOut();
                  break;
                case 'Settings':
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('not implemented yet!')));
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Logout', 'Settings'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice,),
                );
              }).toList();
            },
          ),
        ],
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
        onPressed: () async {
          // String barcode = (await BarcodeScanner.scan()) as String;
          // String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          //     "#ff6666", "Cancel", false, ScanMode.DEFAULT);
          //
          // String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          //     "#ff6666", "Cancel", true, ScanMode.DEFAULT);

          // Provider.of<ApplicationState>(context, listen: false).addDummyDrug();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                // return AddDrugScreen(
                //   serialNumber: barcodeScanRes,
                // );
                // return QRViewExample();

                return QRViewExample();
              },
            ),
          );
        },
      ),
    );
  }
}
