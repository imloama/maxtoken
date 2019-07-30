import 'package:flutter/material.dart';
import 'package:maxtoken/utils/commons.dart';
import 'package:maxtoken/theme/theme.dart';
// import 'package:stellar_hd_wallet/stellar_hd_wallet.dart';
import 'package:maxtoken/hdwallet/hdwallet.dart';
import 'package:maxtoken/hdwallet/kp.dart';
import 'package:hex/hex.dart';
import 'package:maxtoken/hdwallet/ed25519.dart' as ed25519;
import 'dart:typed_data';
/**
 * home page
 * my wallet page
 */
class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }

}

class _HomePageState extends State<HomePage>{

   /// 单击提示退出
  Future<bool> _dialogExitApp(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => new AlertDialog(
              content: new Text(Commons.getLocale(context).app_back_tip),
              actions: <Widget>[
                new FlatButton(onPressed: () => Navigator.of(context).pop(false), child: new Text(Commons.getLocale(context).cancel)),
                new FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: new Text(Commons.getLocale(context).ok))
              ],
            ));
  }

  Widget _body(){
    final mnemonic =
        "illness spike retreat truth genius clock brain pass fit cave bargain toe";
     final wallet = StellarHDWallet.fromMnemonic(mnemonic);
    final seedhex = HEX.encode(wallet.seed);
    final key = wallet.derivePath("m/44'/148'/0'");
    final seedlist = key.sublist(0,32);
    final pathhex = HEX.encode(seedlist);
    final keypair = KeyPair.fromSecretSeedList(seedlist);
    
    // final keypair = wallet.getKeyPair();
    final pubkeyhex = HEX.encode(keypair.publicKey);
    final prikeyhex = HEX.encode(keypair.privateKey);

     final ekp = new ed25519.KeyPair(32, 64);
    Uint8List pk = ekp.publicKey;
    Uint8List sk = ekp.secretKey;
     for (int i = 0; i < 32; i++) {
      sk[i] = seedlist[i];
    }
    final result = ed25519.TweetNaclFast.crypto_sign_keypair(pk, sk, true);
    print("pkhex:" + HEX.encode(pk));
    print("skhex:" + HEX.encode(sk));
    print("result：" + result.toString());

    return Column(
      children: <Widget>[
        Text("seedhex:" + seedhex),
        Text("pathhex:" + pathhex),
        Text("pubkeyhex:" + pubkeyhex),
        Text("prikeyhex:" + prikeyhex),
        Text("accountid:" + keypair.accountId),
        Text("str accountid:" + StrKey.encodeStellarAccountId(keypair.publicKey)),
        Text("2019-0730-2200"),
        Text("pkhex:" + HEX.encode(pk)),
        Text("skhex:" + HEX.encode(sk)),
        Text("result：" + result.toString()),

      ],
    );
  }

  @override 
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()=> _dialogExitApp(context),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: <Widget>[Text("BTC"),Icon(Icons.arrow_drop_down)],
          ),
        ),
        body: Center(
          child: _body(),//Text("home page"),
        ),
      )
    );
  }

}