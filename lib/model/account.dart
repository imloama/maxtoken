import 'package:maxtoken/model/asset.dart';

/// 账户信息
class Account{
  /// 地址
  String address;
  /// 余额
  List<Asset> balances;
  /// 其他数据,恒星系统会用到如homedomain\sequence\subentry_count\inflation_destination\low_threshold\med_threshold\high_threshold\
  Map<String,String> data = Map();

  Account(this.address, this.balances);

}




/// stellar account
class StellarAccount extends Account{
  StellarAccount(String address, List<Asset> balances) : super(address, balances);
  int sequenceNumber;
  int subentryCount;
  String inflationDestination;
  Map<String,int> thresholds;
  Map<String,bool> flags;


}