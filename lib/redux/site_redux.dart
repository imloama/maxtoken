import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:maxtoken/model/site.dart';


///通过 flutter_redux 的 combineReducers，实现 Reducer 方法
final SiteReducer = combineReducers<Site>([
  ///将 Action 、处理 Action 的方法、State 绑定
  TypedReducer<Site, RefreshSiteAction>(_refresh),
]);

///定义处理 Action 行为的方法，返回新的 State
Site _refresh(Site site, action) {
  site = action.site;
  return site;
}

///定义一个 Action 类
///将该 Action 在 Reducer 中与处理该Action的方法绑定
class RefreshSiteAction {

  final Site site;

  RefreshSiteAction(this.site);
}