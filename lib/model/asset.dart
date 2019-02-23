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
  /// 其他数据，针对恒星系，包括limit、buying_liabilities、selling_liabilities、asset_type
  Map<String,String> data = Map();
  Asset(this.code,this.issuer, this.host, this.isNative,this.balance);
}


class StellarAsset extends Asset{
  StellarAsset(String code, String issuer, String host, bool isNative, String balance) : super(code, issuer, host, isNative, balance);
  String limit;
  String buyingLiabilities;
  String sellingLiabilities;
  String assetType;
}

class EthereumAsset extends Asset{
  
  EthereumAsset(String code, String issuer, String host, bool isNative, String balance) : super(code, issuer, host, isNative, balance);


}

class EthereumNativeAsset extends EthereumAsset{
  EthereumNativeAsset(String balance) : super('ETH', null, null, true, balance) ;

}