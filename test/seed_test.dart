import 'package:maxtoken/service/blockchain.dart';
import 'package:pointycastle/digests/sha512.dart';
import 'package:pointycastle/export.dart';
import 'package:stellar/stellar.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:bitcoin_flutter/src/payments/p2pkh.dart';
import 'package:bitcoin_flutter/bitcoin_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hex/hex.dart';
import 'package:tweetnacl/tweetnacl.dart' as ed25519;
// import 'package:crypto/crypto.dart';
import "package:pointycastle/pointycastle.dart";
import 'dart:typed_data';
import 'dart:convert';

void main() {

// 结果不正确
// testStellar().then((data){
//   print("ok");
// }).catchError((err){
//   print(err);
// });
testStellar3();
   
// testBtc();

// testBtc2();// 符合预期
}


Future testStellar() async {
  //final  mnemonic = await bip39.generateMnemonic();
   final mnemonic = "praise you muffin lion enable neck grocery crumble super myself license ghost";
  final  seed = bip39.mnemonicToSeed(mnemonic);
  print(HEX.encode(seed));
  //ed25519-hd-key
  final root = bip32.BIP32.fromSeed(seed);
  final node = root.derivePath("m/44'/148'/0'");
  print(HEX.encode(node.fingerprint));
  print(HEX.encode(node.identifier));
  print(HEX.encode(node.privateKey));
  print(HEX.encode(node.publicKey));
  KeyPair kp = KeyPair.fromSecretSeedList(node.identifier);
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
  var node = root.derivePath("m/44'/148'/0'");
  print("1:"+HEX.encode(node.privateKey));
  print("2:"+HEX.encode(node.publicKey));
  // node = node.derive(0);
  // print("3:"+HEX.encode(node.privateKey));
  // print("4:"+HEX.encode(node.publicKey));
  //参考 https://github.com/stellar/js-stellar-base/blob/master/src/keypair.js
  KeyPair kp = KeyPair.fromSecretSeedList(node.privateKey);
  print(kp.accountId);
  print(kp.secretSeed);

}


Uint8List createUint8ListFromString(String s) {
  var ret = new Uint8List(s.length);
  for (var i = 0; i < s.length; i++) {
    ret[i] = s.codeUnitAt(i);
  }
  return ret;
}

const HIGHEST_BIT = 0x80000000;

Uint8List drive(Uint8List seed, Uint8List chainCode, int index){
  print("index===" + index.toString());
  print("seed:" + HEX.encode(seed));
  print("chainCode:" + HEX.encode(chainCode));
  var y = 2147483648 + index;
  Uint8List data = new Uint8List(37);
  data[0] = 0x00;
  data.setRange(1, 33, seed);
  data.buffer.asByteData().setUint32(33, y);
  print("data==" + HEX.encode(data));
  SHA512Digest digest = SHA512Digest();
  KeyParameter parameter = new KeyParameter(chainCode);
  HMac hmac = HMac(digest,128);
  hmac.init(parameter);
  hmac.reset();
  hmac.update(data, 0, data.length);
  var output = Uint8List(64);
  hmac.doFinal(output, 0);
  return output;
}

void testStellar3(){
  //数据来自https://github.com/stellar/stellar-protocol/blob/master/ecosystem/sep-0005.md
  final mnemonic = "illness spike retreat truth genius clock brain pass fit cave bargain toe";
  final seed = bip39.mnemonicToSeed(mnemonic);
  print(HEX.encode(seed));//正确
  // var key = utf8.encode("ed25519 seed");
  final key = createUint8ListFromString("ed25519 seed");
  KeyDerivator derivator = new KeyDerivator("SHA-512/HMAC/PBKDF2");
  // CipherParameters parameters =new Pbkdf2Parameters(key, 100, 64);
  KeyParameter parameter = new KeyParameter(key);
  // derivator.init(parameter);
  SHA512Digest digest = SHA512Digest();
  // final output = derivator.process(seed);
  // derivator.process(seed);
  HMac hmac = HMac(digest,128);
  hmac.init(parameter);
  hmac.reset();
  hmac.update(seed, 0, seed.length);
  var output = Uint8List(64);
  hmac.doFinal(output, 0);
  print(HEX.encode(output));//correct
  // //恒星 m/44'/148'/0' key:
  // byte[] i44 = derive(extendedKey.getMaster().getRawPrivateKey(), extendedKey.getChainCode(), 44);
  // byte[] i148 = derive(Arrays.copyOfRange(i44, 0, 32), Arrays.copyOfRange(i44, 32, 64), 148);
  // byte[] i0 = derive(Arrays.copyOfRange(i148, 0, 32), Arrays.copyOfRange(i148, 32, 64), 0);
  var left = output.sublist(0,32);
  var right = output.sublist(32,64);
  print("left:"+left.length.toString()+","+HEX.encode(left));
  print("right:"+right.length.toString()+","+HEX.encode(right));

  Uint8List i44 = drive(left, right, 44);
  print("44:" + HEX.encode(i44));
  var i148 = drive(i44.sublist(0,32), i44.sublist(32), 148);
  print("148:" + HEX.encode(i148));
  var i0 = drive(i148.sublist(0,32), i148.sublist(32), 0);
  KeyPair kp = KeyPair.fromSecretSeedList(i0.sublist(0,32));
  print(kp.accountId);
  print(kp.secretSeed);

}

Future testBtc() async{
  final mnemonic = "illness spike retreat truth genius clock brain pass fit cave bargain toe";
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