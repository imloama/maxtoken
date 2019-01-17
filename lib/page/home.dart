import 'package:flutter/material.dart';
import 'package:maxtoken/utils/commons.dart';

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

  @override 
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()=> _dialogExitApp(context),
      child: Center(
          child: Text("Hello, MTToken"),
        ),
    );
  }

}