import 'dart:typed_data';

import 'package:maxtoken/service/blockchain.dart';
import 'package:stellar/stellar.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:bitcoin_flutter/src/payments/p2pkh.dart';
import 'package:stellar_hd_wallet/stellar_hd_wallet.dart';


class KeyPairs{



  static KeyPairData random(BlockChainType type){
    switch(type){
      case BlockChainType.Stellar:
        return null;//randomForStellar();
        break;
      case BlockChainType.BitCoin:
        break;
      case BlockChainType.Ethereum:
        break;
      default:
        break;
    }
    return null;
  }

  static Future<KeyPairData> randomForStellar({int index = 0}) async {
      // KeyPair kp = KeyPair.random();
      final mnemonic = StellarHDWallet.generateMnemonic();
      final wallet = StellarHDWallet.fromMnemonic(mnemonic);
      final kp = wallet.getKeyPair(index: index);
      return KeyPairData(
        mnemonic: mnemonic,
        publicKey: kp.accountId,
        secret: kp.secretSeed,
      );
  }


  static Future<KeyPairData> _randomForBitcoin() async {
    // Only support BIP39 English word list
    // uses HEX strings for entropy
   final mnemonic = "praise you muffin lion enable neck grocery crumble super myself license ghost";
    final seed = bip39.mnemonicToSeed(mnemonic); 
    final root = bip32.BIP32.fromSeed(seed);
    final path = root.derivePath("m/44'/0'/0'/0/0");
    final data = new P2PKHData(pubkey: path.publicKey);
    final p2pkh = P2PKH(data: data);
      return KeyPairData(
        mnemonic: mnemonic,
        publicKey: p2pkh.data.address,
        secret: path.toWIF()
      );
  }

  static String getBTCAddress (bip32.BIP32 node, [network]) {
    return P2PKH(data: new P2PKHData(pubkey: node.publicKey), network: network).data.address;
  }


}

class KeyPairData{
  final String mnemonic;
  final String publicKey;
  final String secret;

  KeyPairData({this.mnemonic,this.publicKey, this.secret});


}
