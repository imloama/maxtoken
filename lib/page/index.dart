/**
 * index page
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './home.dart';
import './my.dart';
import './explorer.dart';
import '../utils/commons.dart';

class IndexPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _IndexPageState();
  }

}

class _IndexPageState extends State<IndexPage>{

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

  int _tabIndex = 0;

  BottomNavigationBar _navbar(BuildContext context){
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home)
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore)
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person)
        )
      ],
      type: BottomNavigationBarType.fixed,
      iconSize: 24.0,
      currentIndex: _tabIndex,
      onTap: (index){
        setState(() {
                  _tabIndex = index;
                });
      },
    );
  }

  var _pages = [HomePage(),ExplorerPage(),MyPage()];

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: _navbar(context),
        body: _pages[_tabIndex]
      );
  }

}