import 'package:maxtoken/service/blockchain.dart';
import 'package:stellar/stellar.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:bitcoin_flutter/src/payments/p2pkh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

testStellar().then((data){
  print("ok");
}).catchError((err){
  print(err);
});
   

}

Future testStellar() async {
  final  mnemonic = await bip39.generateMnemonic();
  final  seed = bip39.mnemonicToSeed(mnemonic);
  final secret = seed.map((byte) {
    return byte.toRadixString(16).padLeft(2, '0');
  }).join('');
  print(secret);
  //ed25519-hd-key
  final root = bip32.BIP32.fromSeed(seed);
  final node = root.derivePath("m/44'/148'/0'");
  KeyPair kp = KeyPair.fromSecretSeedList(node.privateKey);
  print(mnemonic);
  print(kp.accountId);
  print(kp.secretSeed);
}