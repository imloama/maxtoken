import 'package:maxtoken/service/blockchain.dart';
import 'package:pointycastle/digests/sha512.dart';
import 'package:pointycastle/digests/sha3.dart';
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
import 'package:convert/convert.dart';
import 'package:pointycastle/src/utils.dart' as p_utils;

void main() {
  testEth();
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

void testStellar(){
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
final int SEED_ITERATIONS = 2048;
final int SEED_KEY_SIZE = 64;

void testEth(){
  final mnemonic = "praise you muffin lion enable neck grocery crumble super myself license ghost";
  // passphrase = passphrase == null ? "" : passphrase;
  // String salt = "mnemonic$passphrase";
  // KeyDerivator derivator = new PBKDF2KeyDerivator(new HMac(new SHA512Digest(), 128));
  // Pbkdf2Parameters parameter = new Pbkdf2Parameters(utf8.encode(salt), SEED_ITERATIONS, SEED_KEY_SIZE);
  // derivator.init(parameter);
  // var masterSeedByteArray = derivator.process(utf8.encode(mnemonic));
  // final root = bip32.BIP32.fromPrivateKey(masterSeedByteArray.sublist(0,32), masterSeedByteArray.sublist(32));
  // final path = root.derivePath("m/44'/60'/0'/0/0");
  final seed = bip39.mnemonicToSeed(mnemonic); 
  print(HEX.encode(seed));
  final root = bip32.BIP32.fromSeed(seed);
  print("root:" + HEX.encode(root.privateKey));
  final path = root.derivePath("m/44'/60'/0'/0/0");
  //Credentials fromHex = Credentials.fromPrivateKeyHex(HEX.encode(path.privateKey));
  // print(HEX.encode(path.privateKey));
  print(path.privateKey.length);
  print(path.toBase58());//正确
  print("0x"+HEX.encode(path.publicKey));//正确

  var secretHex = "0x"+HEX.encode(path.privateKey);
  print(secretHex);//正确
  
  //输出地址
  var pubkey = HEX.encode(path.publicKey).toLowerCase();

  //ECCurve_secp256k1 secp256k1 = ECCurve_secp256k1();
  SHA3Digest keccak = SHA3Digest(256);
  var address = keccak.process(HEX.decode(pubkey));
  //print(HEX.encode(address));
  address = address.sublist(address.length-20);
  print(address.length);
  //print(HEX.encode(address));
  Uint8List list = Uint8List(20);
  // for (var item in address) {
  //   if(item<)
  // }


  //var number = bytesToInt(path.publicKey);
  //print("number:" + number.toString());
  //print(toHex(number,pad: true, forcePadLen: _ethAddLenBytes * 2, include0x: true));
  //print(HEX.encode(privateKeyToPublic(path.privateKey)));



  /**
   hdkey js
    var I = crypto.createHmac('sha512', MASTER_SECRET).update(seedBuffer).digest()
  var IL = I.slice(0, 32)
  var IR = I.slice(32)

  var hdkey = new HDKey(versions)
  hdkey.chainCode = IR
  hdkey.privateKey = IL


   let wallet = hdKey.getWallet();
    let secret = wallet.getPrivateKeyString().substring(2);
    let address = wallet.getChecksumAddressString();

   */

}
const int _ethAddLenBytes = 20;

List<int> numberToBytes(dynamic number) {
  if (number is BigInt)
    return p_utils.encodeBigInt(number);

	var hexString = toHex(number, pad: true);
	return hex.decode(hexString);
}
final ECDomainParameters params = new ECCurve_secp256k1();
Uint8List privateKeyToPublic(Uint8List privateKey) {
	var privateKeyNum = bytesToInt(privateKey);
	var p = params.G * privateKeyNum;

	//skip the type flag, https://github.com/ethereumjs/ethereumjs-util/blob/master/index.js#L319
	return p.getEncoded(false).sublist(1);
}

 BigInt _privateKeyToPublic(BigInt private) {
    var privateKeyBytes = numberToBytes(private);
    var publicKeyBytes = privateKeyToPublic(privateKeyBytes);
    return bytesToInt(publicKeyBytes);
  }

BigInt bytesToInt(List<int> bytes) => p_utils.decodeBigInt(bytes);

String toHex(dynamic number, {bool pad = false, bool include0x = false, int forcePadLen}) {
	String toHexSimple() {
		if (number is int)
			return number.toRadixString(16);
		else if (number is BigInt)
			return number.toRadixString(16);
		else
			throw new TypeError();
	}

	var hexString = toHexSimple();
	if (pad && !hexString.length.isEven)
		hexString = "0$hexString";
  if (forcePadLen != null)
    hexString = hexString.padLeft(forcePadLen, "0");
	if (include0x)
		hexString = "0x$hexString";

	return hexString;
}

