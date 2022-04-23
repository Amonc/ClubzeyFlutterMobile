import 'dart:developer';
import 'dart:io';

import 'package:Clubzey/backend/datastore/club_data.dart';
import 'package:Clubzey/components/custom_snackbar.dart';
import 'package:Clubzey/components/labels.dart';
import 'package:Clubzey/models/encrypted_id.dart';
import 'package:Clubzey/utils/encryption.dart';
import 'package:Clubzey/utils/fontSize.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrCodeScanner extends StatefulWidget {
  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  Barcode? result;
  QRViewController? controller;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool _loading = false;

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
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: !_loading ?_buildQrView(context):Center(child: CircularProgressIndicator(),)),

        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 500 ||
            MediaQuery.of(context).size.height < 500)
        ? 250.0
        : 500.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.lightGreenAccent,
          borderRadius: 5,
          borderLength: 40,
          borderWidth: 6,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() async {
        result = scanData;
        if(result!=null){
       List<String> code=   Encryption().decrypted(encrypted: Encrypted.fromBase16(result!.code!)).split("*");
       EncryptedId encryptedId=EncryptedId(code: code);
       controller.dispose();
       _loading= true;
       if(DateTime.now().difference(encryptedId.getDateTime).inSeconds<31&&DateTime.now().difference(encryptedId.getDateTime).inSeconds>0 ){
     await ClubData().addMember(encryptedId: encryptedId, share:encryptedId.share );
     Navigator.pop(context);
     Navigator.pop(context);
       }else{
         CustomSnackbar(context: context, text: "Qr has been Expired").show();
       }



        }

      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {

    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
