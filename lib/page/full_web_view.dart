import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class FullWebView extends StatelessWidget{
  final String url;
  final String title;

  FullWebView(this.url, this.title);

   _renderTitle() {
    if (url == null || url.length == 0) {
      return new Text(title);
    }
    //optionControl.url = url;
    return new Row(children: [
      new Expanded(child: new Container()),
      //CommonOptionWidget(optionControl),//右侧菜单
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return new WebviewScaffold(
      withJavascript: true,
      url: url,
      scrollBar:true,
      withLocalUrl: true,
      appBar: new AppBar(
        title: _renderTitle(),
      ),
    );
  }

}