import 'package:flutter/material.dart';
import 'package:maxtoken/utils/commons.dart';
import 'package:maxtoken/theme/theme.dart';
import 'package:stellar_hd_wallet/stellar_hd_wallet.dart';

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
    final keypair = wallet.getKeyPair();
    return Text(keypair.accountId);
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