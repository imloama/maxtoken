/**
 * index page
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maxtoken/page/home.dart';
import 'package:maxtoken/page/my.dart';
import 'package:maxtoken/page/explorer.dart';
import 'package:maxtoken/utils/commons.dart';

class IndexPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _IndexPageState();
  }

}

class _IndexPageState extends State<IndexPage>{

  int _tabIndex = 0;

  BottomNavigationBar _navbar(BuildContext context){
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          title:Text(Commons.getLocale(context).home),
          icon: Icon(Icons.home)
        ),
        BottomNavigationBarItem(
          title:Text(Commons.getLocale(context).explore),
          icon: Icon(Icons.explore)
        ),
        BottomNavigationBarItem(
          title:Text(Commons.getLocale(context).my),
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