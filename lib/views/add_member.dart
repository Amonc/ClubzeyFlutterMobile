import 'package:Clubzey/backend/dio/send_invitation_code_data.dart';
import 'package:Clubzey/components/buttons.dart';
import 'package:Clubzey/components/labels.dart';
import 'package:Clubzey/models/club.dart';
import 'package:Clubzey/utils/allColors.dart';
import 'package:Clubzey/utils/encryption.dart';
import 'package:Clubzey/utils/fontSize.dart';
import 'package:Clubzey/utils/helper.dart';
import 'package:Clubzey/views/create_invitation_code_page.dart';
import 'package:encrypt/encrypt.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class AddMemberPage extends StatelessWidget {
  final Club club;
  final int shares;
  AddMemberPage({required this.club, required this.shares});

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
                        .encrypted(
                            code: '${club.getId}*${_qrCreated}*${shares}')
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
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Label(
                        text: ("Scan within "),
                        fontSize: FontSize.h4,
                      ),
                      Label(
                        text: (snapshot.data ?? "$_timerSeconds").toString(),
                        fontSize: FontSize.h4,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  );
                },
              ),

//               FillButton(title: 'test', onPressed: (){
//                String a= ;
//                String b=Encryption().decrypted(encrypted: Encrypted.fromBase16(a));
// print("$a $b");
//
//               }),

              SizedBox(
                height: 15,
              ),

              Label(
                text: ('Or'),
                fontWeight: FontWeight.w500,
                fontSize: FontSize.p1,
              ),
              SizedBox(
                height: 15,
              ),
              FillButton(
                title: 'Create invitation code',
                onPressed: () async {


                  Navigator.push(context, MaterialPageRoute(builder: (context)=> CreateInvitationPage(club: club, shares: shares,)));

                  // InvitationCodeData().createInvitationCode(club: club);






                  // ShortDynamicLink shorDynamiclink=     await createShortDynamiclink(clubId: club.getId,shares: shares);
                  //       Share.share('To get started with ${club.getName} please use this link: ${shorDynamiclink.shortUrl}');
                },
                containerColor: AllColors.yellow,
                textColor: AllColors.fontBlack,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<ShortDynamicLink> createShortDynamiclink(
      {required String clubId, required int shares}) async {
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse("https://clubzey.web.app/${clubId}*${shares}"),
      uriPrefix: "https://clubzeyapp.page.link",
      androidParameters:
          const AndroidParameters(packageName: "aerobola.clubzey"),
      iosParameters: const IOSParameters(bundleId: "aerobola.clubzey"),
    );
    return await FirebaseDynamicLinks.instance
        .buildShortLink(dynamicLinkParams);
  }
}
