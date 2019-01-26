import 'dart:typed_data';

import 'package:maxtoken/service/blockchain.dart';
import 'package:stellar/stellar.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:bitcoin_flutter/src/payments/p2pkh.dart';


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
      final  mnemonic = await bip39.generateMnemonic();
      final  seed = bip39.mnemonicToSeed(mnemonic);
      final secret = seed.map((byte) {
        return byte.toRadixString(16).padLeft(2, '0');
      }).join('');
      //ed25519-hd-key
      final root = bip32.BIP32.fromSeed(seed);
      final path = "m/44'/148'/$index'";
      final node = root.derivePath(path);
      KeyPair kp = KeyPair.fromSecretSeedList(seed);
      return KeyPairData(
        mnemonic: mnemonic,
        publicKey: kp.accountId,
        secret: kp.secretSeed,
      );
  }


  static Future<KeyPairData> _randomForBitcoin() async {
    // Only support BIP39 English word list
    // uses HEX strings for entropy
    final  mnemonic = await bip39.generateMnemonic();
      final  seed = bip39.mnemonicToSeed(mnemonic);
      final secret = seed.map((byte) {
        return byte.toRadixString(16).padLeft(2, '0');
      }).join('');
      //ed25519-hd-key
      final root = bip32.BIP32.fromSeed(seed);
      final address = getBTCAddress(root.derivePath("m/0'/0/0"));
      return KeyPairData(
        mnemonic: mnemonic,
        publicKey: address,
        secret: secret
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