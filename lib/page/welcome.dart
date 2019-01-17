import 'package:flutter/material.dart';
import 'package:maxtoken/utils/commons.dart';
import 'package:maxtoken/utils/navigators.dart';

class WelcomePage extends StatefulWidget {
  
  @override
  _WelcomePageState createState() => _WelcomePageState();
 

}

class _WelcomePageState extends State<WelcomePage>  {

  bool hadInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(hadInit) {
      return;
    }
    hadInit = true;
    ///防止多次进入
    //Store<GSYState> store = StoreProvider.of(context);
    Commons.initStatusBarHeight(context);
    // new Future.delayed(const Duration(seconds: 2), () {
    //   UserDao.initUserInfo(store).then((res) {
    //     if (res != null && res.result) {
    //       NavigatorUtils.goHome(context);
    //     } else {
    //       NavigatorUtils.goLogin(context);
    //     }
    //     return true;
    //   });
    // });
    Navigators.goHome(context);
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
          child: new Center(
            child: new Image(image: new AssetImage('static/images/welcome.png')),
          ),
        );
  }

}