import 'package:stellar_hd_wallet/stellar_hd_wallet.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:maxtoken/model/asset.dart';
import 'package:maxtoken/model/account.dart';

abstract class Service{

  /// 查询余额
  Future<Account> getBalance(String address);

}


abstract class Address{
   //助记词
  String mnemonic = null;
  int index = 0;
  //公钥
  String address = null;
  //私钥
  String secret = null;

  Address.fromPublicAddress(String address){
    this.address = address;
  }

  Address.fromSecret(String secret){
    this.secret = secret;
  }

  Address.fromMnemonic(String mnemonic,[int index = 0]){
    this.mnemonic = mnemonic;
    this.index = index;
  }

  ///生成随机助记词
  static String random({int strength = ENTROPY_BITS_HALF,
      language = 'english',
      bip39.RandomBytes random}){
    return StellarHDWallet.generateMnemonic(strength: strength, language: language, random: random);
  }


}