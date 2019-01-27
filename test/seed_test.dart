import 'package:maxtoken/service/blockchain.dart';
import 'package:stellar/stellar.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:bitcoin_flutter/src/payments/p2pkh.dart';
import 'package:bitcoin_flutter/bitcoin_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hex/hex.dart';

void main() {

// 结果不正确
// testStellar().then((data){
//   print("ok");
// }).catchError((err){
//   print(err);
// });
testStellar2();
   
// testBtc();

// testBtc2();// 符合预期
}


Future testStellar() async {
  //final  mnemonic = await bip39.generateMnemonic();
   final mnemonic = "praise you muffin lion enable neck grocery crumble super myself license ghost";
  final  seed = bip39.mnemonicToSeed(mnemonic);
  //ed25519-hd-key
  final root = bip32.BIP32.fromSeed(seed);
  final node = root.derivePath("m/44'/148'/0'");
  KeyPair kp = KeyPair.fromSecretSeedList(node.privateKey);
  print(mnemonic);
  print(kp.accountId);//应该是： GCBERPX2R2QNKNKPL6HDKYZJE5ZONX6HOZUZBPZANUHJUG6N7KB6JDBE
  print(kp.secretSeed);
}

void testStellar2(){
  //数据来自https://github.com/stellar/stellar-protocol/blob/master/ecosystem/sep-0005.md
  final mnemonic = "illness spike retreat truth genius clock brain pass fit cave bargain toe";
  final seed = bip39.mnemonicToSeed(mnemonic);
  print(HEX.encode(seed));//正确
  final root = bip32.BIP32.fromSeed(seed);
  final node = root.derivePath("m/44'/148'/0'");
  print(HEX.encode(node.privateKey));
  print(HEX.encode(node.publicKey));
  KeyPair kp = KeyPair.fromSecretSeedList(node.privateKey);
  print(kp.accountId);
  print(kp.secretSeed);

}

Future testBtc() async{
  final mnemonic = "praise you muffin lion enable neck grocery crumble super myself license ghost";
  final  seed = bip39.mnemonicToSeed(mnemonic); 
  var hdWallet = HDWallet.fromSeed(seed);
  print(hdWallet.address);
  print(hdWallet.pubKey);
  print(hdWallet.privKey);
  print(hdWallet.wif);
}

Future testBtc2() async{
  final mnemonic = "praise you muffin lion enable neck grocery crumble super myself license ghost";
  final seed = bip39.mnemonicToSeed(mnemonic); 
  final root = bip32.BIP32.fromSeed(seed);
  final path = root.derivePath("m/44'/0'/0'/0/0");
  final data = new P2PKHData(pubkey: path.publicKey);
  final p2pkh = P2PKH(data: data);
  print(p2pkh.data.address);
  // print(data.pubkey);
  // final privateKey = HEX.encode(path.privateKey);
  // print(privateKey);
  print(path.toWIF());
}