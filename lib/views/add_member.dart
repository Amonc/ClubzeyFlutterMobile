import 'package:Clubzey/components/buttons.dart';
import 'package:Clubzey/components/labels.dart';
import 'package:Clubzey/models/club.dart';
import 'package:Clubzey/utils/allColors.dart';
import 'package:Clubzey/utils/encryption.dart';
import 'package:Clubzey/utils/helper.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AddMemberPage extends StatelessWidget {
  final Club club;

  AddMemberPage({required this.club});

  int _timerSeconds = 30;
  DateTime _qrCreated = DateTime.now();
  Stream<int> timerCount(Duration interval, [int? minCount]) async* {
    int i = _timerSeconds;
    while (true) {
      await Future.delayed(interval);
      yield i--;
      if (i == minCount) {
        i = _timerSeconds;
      }
    }
  }

  Stream<int> qrReload(Duration interval, [int? minCount]) async* {
    int i = _timerSeconds;
    while (true) {
      await Future.delayed(interval);
      yield i--;
      _qrCreated = DateTime.now();
      if (i == minCount) {
        i = _timerSeconds;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: CupertinoButton(
            padding: EdgeInsets.all(0),
            minSize: 0,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Icon(
              CupertinoIcons.chevron_left,
              color: AllColors.fontBlack,
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Label(text: "QR Code"),
              StreamBuilder(
                stream: qrReload(Duration(seconds: _timerSeconds)),
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  print(_qrCreated.toString());
                  return QrImage(
                    data: Encryption()
                        .encrypted(code: '${club.getId}*${_qrCreated}')
                        .base16,
                    version: QrVersions.auto,
                    size: 320,
                    gapless: false,
                    embeddedImage: AssetImage('assets/images/ic_logo.png'),
                    embeddedImageStyle: QrEmbeddedImageStyle(
                      size: Size(60, 60),
                    ),
                  );
                },
              ),
              StreamBuilder(
                stream: timerCount(Duration(seconds: 1), 0),
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  return Label(
                      text: (snapshot.data ?? "$_timerSeconds").toString());
                },
              ),

//               FillButton(title: 'test', onPressed: (){
//                String a= ;
//                String b=Encryption().decrypted(encrypted: Encrypted.fromBase16(a));
// print("$a $b");
//
//               })
            ],
          ),
        ),
      ),
    );
  }
}
