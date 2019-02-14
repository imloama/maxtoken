
import 'package:maxtoken/service/blockchain.dart';
import 'package:stellar/stellar.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:bitcoin_flutter/src/payments/p2pkh.dart';
import 'package:stellar_hd_wallet/stellar_hd_wallet.dart';

class HDWallet{

  String _mnemonic;
  String _publicKey;
  String _secret;

  HDWallet._();

  HDWallet.random(){
    _mnemonic = StellarHDWallet.generateMnemonic();
  }

  String get BTCPublicKey{
    if(_publicKey!=null)return _publicKey;
    if(_secret!=null){
      // 根据私钥生成公钥
    }
    //根据助记词生成公钥

  }

  String get StellarPublicKey{
    
  }


}
