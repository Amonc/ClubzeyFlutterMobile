// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:Clubzey/backend/datastore/transaction_data.dart';
import 'package:Clubzey/components/buttons.dart';
import 'package:Clubzey/models/transactions.dart';
import 'package:Clubzey/models/user_payment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:uuid/uuid.dart';

import '../backend/auth/model/clubzey_user.dart';
import '../backend/datastore/auth_data.dart';
import '../components/avatars.dart';
import '../components/cards.dart';
import '../components/labels.dart';
import '../utils/fontSize.dart';
import '../utils/helper.dart';

class PaymentDetailsPage extends StatelessWidget {
  PaymentDetailsPage(
      {Key? key,
      required this.paymentDetails,
      required this.clubzeyUser,
      required this.clubId})
      : super(key: key);

  final PaymentDetails paymentDetails;
  final ClubzeyUser clubzeyUser;
  final String clubId;
  final _formKey = GlobalKey<FormState>();
  double _amount = 0.00;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(children: [
          Center(
            child: Container(
                height: 100,
                width: 100,
                child: LetterAvatar(
                  color: Colors.red,
                  letter: clubzeyUser.getUsername.substring(0, 1),
                  fontSize: FontSize.h1,
                )),
          ),
          SizedBox(
            height: 8,
          ),
          Label(
            text: clubzeyUser.getUsername,
            fontSize: FontSize.h3,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(
            height: 5,
          ),
          Label(
            text: clubzeyUser.getEmail,
            fontSize: FontSize.p1,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(
            height: 20,
          ),
          StreamBuilder(
            stream: TransactionData()
                .get(clubId: clubId, email: clubzeyUser.getEmail),
            builder: (BuildContext context,
                AsyncSnapshot<List<ClubTransaction>> snapshot) {
              if (snapshot.data == null) {
                SizedBox();
              }

              List<ClubTransaction> clubTransactions = snapshot.data ?? [];

              return ListView.builder(
                shrinkWrap: true,
                itemCount: clubTransactions.length,
                itemBuilder: (BuildContext context, int index) {
                  return TransactionCard(
                    transId: clubTransactions[index].getId,
                    createdAt: clubTransactions[index].createAt,
                    amount: clubTransactions[index].getAmount,
                    cycle: clubTransactions[index].getCycle,
                  );
                },
              );
            },
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showMaterialModalBottomSheet(
            context: context,
            builder: (context) => Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              height: 200,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      decoration:
                          const InputDecoration(hintText: "Give your amount"),
                      validator: (value){


                        if (value == null || value.isEmpty) {
                          return 'Please enter your amount';
                        }
                        _amount=double.parse(value);


                        return null;
                      },



                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CupertinoButton(
                        onPressed: () async {
                          if(_formKey.currentState!.validate()){
                            ClubTransaction clubTransaction= ClubTransaction(data: {
                              "id":"${Uuid().v4().substring(0,5)}${DateTime.now().millisecond}",
                              "clubId":clubId,
                              "amount":_amount,
                              "createdAt":DateTime.now(),
                              "payor":clubzeyUser.getEmail,
                              "cycle":1

                            });
                            await TransactionData().createTransaction(clubTransaction: clubTransaction);
                            Navigator.pop(context);



                          }
                        },
                        padding: EdgeInsets.all(0),
                        child: Label(
                          text: "Done",
                          fontSize: FontSize.h5,
                          fontWeight: FontWeight.bold,
                        ))
                  ],
                ),
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}


