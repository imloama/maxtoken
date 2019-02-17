import 'package:maxtoken/service/service.dart';
import 'package:stellar/stellar.dart';
import 'package:stellar_hd_wallet/stellar_hd_wallet.dart';


/// 恒生服务功能
class StellarService {
  
}

/// 恒星地址服务
class StellarAddress extends Address{

  KeyPair _keypair;

  StellarAddress.fromPublicAddress(String address) : super.fromMnemonic(address);
  StellarAddress.fromSecret(String secret) : super.fromMnemonic(secret){
    //根据私钥生成公钥
    this._keypair = KeyPair.fromSecretSeed(secret);
    this.address = this._keypair.accountId;
  }
  StellarAddress.fromMnemonic(String mnemonic,[int index = 0]) : super.fromMnemonic(mnemonic){
    final wallet = StellarHDWallet.fromMnemonic(mnemonic);
    this._keypair = wallet.getKeyPair(index: index);
    this.address = this._keypair.accountId;
    this.secret = this._keypair.secretSeed;
  }

}