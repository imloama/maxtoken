/// 资产

class Asset {
  /// 资产编码
  String code;
  /// 资产发行方，或合约编码
  String issuer;
  /// 资产发行方网站
  String host;
  /// 是否内置资产
  bool isNative;
  /// 余额展示
  String balance;
  Asset(this.code,this.issuer, this.host, this.isNative,this.balance);
}