import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_manager/pages/add_drug/add_drug.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

// void main() => runApp(MaterialApp(home: QRViewExample()));

class QRViewExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Expanded( child: _buildQrView(context)),
          FittedBox(
            fit: BoxFit.contain,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // if (result != null)
                //   Text(
                //       'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                // else
                //   Text('Scan a code'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(8),
                      child: IconButton(
                          onPressed: () async {
                            await controller?.toggleFlash();
                            setState(() {});
                          },
                          icon: FutureBuilder(
                            future: controller?.getFlashStatus(),
                            builder: (context, snapshot) {
                              return Icon(snapshot.data as bool?Icons.flash_on:Icons.flash_off,color: Colors.white,);
                            },
                          )),
                    ),
                    // Container(
                    //   margin: EdgeInsets.all(8),
                    //   child: ElevatedButton(
                    //       onPressed: () async {
                    //         await controller?.flipCamera();
                    //         setState(() {});
                    //       },
                    //       child: FutureBuilder(
                    //         future: controller?.getCameraInfo(),
                    //         builder: (context, snapshot) {
                    //           if (snapshot.data != null) {
                    //             return Text(
                    //                 'Camera facing ${describeEnum(snapshot.data!)}');
                    //           } else {
                    //             return Text('loading');
                    //           }
                    //         },
                    //       )),
                    // )
                  ],
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: <Widget>[
                //     Container(
                //       margin: EdgeInsets.all(8),
                //       child: ElevatedButton(
                //         onPressed: () async {
                //           await controller?.pauseCamera();
                //         },
                //         child: Text('pause', style: TextStyle(fontSize: 20)),
                //       ),
                //     ),
                //     Container(
                //       margin: EdgeInsets.all(8),
                //       child: ElevatedButton(
                //         onPressed: () async {
                //           await controller?.resumeCamera();
                //         },
                //         child: Text('resume', style: TextStyle(fontSize: 20)),
                //       ),
                //     )
                //   ],
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;

    // var scanArea =min(MediaQuery.of(context).size.width,MediaQuery.of(context).size.height)*0.8;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {

        result = scanData;
        print(result!.code);
        if (result !=null && result!.code.isNotEmpty){
          controller.dispose();
          Route route = MaterialPageRoute(builder: (context) => AddDrugScreen(serialNumber: result!.code,));
          Navigator.pushReplacement(context, route);
        }

    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}