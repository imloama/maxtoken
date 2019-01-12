import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import '../model/Wallet.dart';

///通过 flutter_redux 的 combineReducers，实现 Reducer 方法
final WalletReducer = combineReducers<List<Wallet>>([
  ///将 Action 、处理 Action 的方法、State 绑定
  TypedReducer<List<Wallet>, ReloadWalletsAction>(_reload),
]);

///定义处理 Action 行为的方法，返回新的 State
List<Wallet> _reload(List<Wallet> wallets, action) {
  wallets = action.wallets;
  return wallets;
}

///定义一个 Action 类
///将该 Action 在 Reducer 中与处理该Action的方法绑定
class ReloadWalletsAction {

  final List<Wallet> wallets;
  ReloadWalletsAction(this.wallets);
}