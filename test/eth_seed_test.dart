import 'dart:convert';
import 'dart:math';

import 'package:maxtoken/service/blockchain.dart';
import 'package:pointycastle/digests/sha512.dart';
import 'package:pointycastle/digests/sha3.dart';
import 'package:pointycastle/export.dart';
// import 'package:stellar/stellar.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:bitcoin_flutter/src/payments/p2pkh.dart';
import 'package:bitcoin_flutter/bitcoin_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hex/hex.dart';
// import 'package:tweetnacl/tweetnacl.dart' as ed25519;
// import 'package:crypto/crypto.dart';
import "package:pointycastle/pointycastle.dart";
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:pointycastle/src/utils.dart' as p_utils;
import 'package:web3dart/src/wallet/credential.dart';


void main() {
  var rng = new Random.secure();
  var generator = new ECKeyGenerator();
  ECDomainParameters params = new ECCurve_secp256k1();
	var keyParams = new ECKeyGeneratorParameters(params);

	generator.init(new ParametersWithRandom(keyParams, DartRandom(rng)));
	var key = generator.generateKeyPair();
  ECPrivateKey privateKey = key.privateKey;
	var privkey =  privateKey.d;
  print(privkey);
  var pk = intToBytes(privkey);
  print(pk.length);
  print("seed:" + HEX.encode(pk));
  var pubkey = _privateKeyToPublic(privkey);
  var pbk = intToBytes(pubkey);
  print("public length:" + pbk.length.toString());
  print("public:" + HEX.encode(pbk));
  var addresskey = pbk.sublist(pbk.length-20);
  var address = toHex(bytesToInt(addresskey), pad: true, 
    forcePadLen: _ethAddLenBytes * 2, include0x: false);
  print("address:" + address);
  print("hex eip55:" + hexEip55(address));


  print("----------------------------------------------");

  final mnemonic = "praise you muffin lion enable neck grocery crumble super myself license ghost";
  final seed = bip39.mnemonicToSeed(mnemonic); 
  final root = bip32.BIP32.fromSeed(seed);
  final path = root.derivePath("m/44'/60'/0'/0/0");

  print("seed length:" + path.privateKey.length.toString()+", public key length:" + path.publicKey.length.toString());
  print("seed:" + HEX.encode(path.privateKey));
  print("pub:" + HEX.encode(path.publicKey));
  pubkey = _privateKeyToPublic(bytesToInt(path.privateKey));
  pbk = intToBytes(pubkey);
  print("public length:" + pbk.length.toString());
  print("public:" + HEX.encode(pbk.sublist(0,33)));
  print("public:" + HEX.encode(pbk.sublist(31)));
  print("public:" + HEX.encode(pbk));
  addresskey =pbk.sublist(pbk.length - 20);
  address = toHex(bytesToInt(addresskey), pad: true, 
    forcePadLen: _ethAddLenBytes * 2, include0x: false);
  print("address:" + address);
  print("hex eip55:" + hexEip55(HEX.encode(addresskey)));
  
  print("------------------------------2-------------------------------------");
  var pub = Credentials.fromPrivateKeyHex(HEX.encode(path.privateKey)).address.hexEip55;
  print(pub);


}
const int _shaBytes = 256 ~/ 8;
final SHA3Digest sha3digest = new SHA3Digest(_shaBytes * 8);
Uint8List sha3(Uint8List input) {
	sha3digest.reset();
	return sha3digest.process(input);
}
String hexEip55(String hexNo0x){
   // https://eips.ethereum.org/EIPS/eip-55#implementation
    var hex = hexNo0x.toLowerCase();
    var hash = bytesToHex(sha3(ascii.encode(hex)));

    var eip55 = new StringBuffer("0x");
    for (var i = 0; i < hex.length; i++) {
      if (int.parse(hash[i], radix: 16) >= 8) {
        eip55.write(hex[i].toUpperCase());
      } else {
        eip55.write(hex[i]);
      }
    }

    return eip55.toString();
}
String bytesToHex(List<int> bytes, {bool include0x = false}) {
  return (include0x ? "0x" : "") + hex.encode(bytes);
}

 int _ethAddLenBytes = 20;
 BigInt _privateKeyToPublic(BigInt private) {
    var privateKeyBytes = numberToBytes(private);
    var publicKeyBytes = privateKeyToPublic(privateKeyBytes);

    return bytesToInt(publicKeyBytes);
  }
Uint8List privateKeyToPublic(Uint8List privateKey) {
	var privateKeyNum = bytesToInt(privateKey);
  ECDomainParameters params = new ECCurve_secp256k1();
	var p = params.G * privateKeyNum;
	//skip the type flag, https://github.com/ethereumjs/ethereumjs-util/blob/master/index.js#L319
	return p.getEncoded(false).sublist(1);
}
//Converts the bytes from that list (big endian) to a BigInt.
BigInt bytesToInt(List<int> bytes) => p_utils.decodeBigInt(bytes);
List<int> intToBytes(BigInt number) => p_utils.encodeBigInt(number);
List<int> numberToBytes(dynamic number) {
  if (number is BigInt)
    return p_utils.encodeBigInt(number);

	var hexString = toHex(number, pad: true);
	return hex.decode(hexString);
}

/// Converts the hexadecimal string, which can be prefixed with 0x, to a byte
/// sequence.
List<int> hexToBytes(String hexStr) {
	return hex.decode(strip0x(hexStr));
}
String strip0x(String hex) {
	if (hex.startsWith("0x"))
		return hex.substring(2);
	return hex;
}
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

class DartRandom implements SecureRandom {

	Random dartRandom;

	DartRandom(this.dartRandom);

  @override
  String get algorithmName => "DartRandom";

  @override
  BigInt nextBigInteger(int bitLength) {
    var fullBytes = bitLength ~/ 8;
    var remainingBits = bitLength % 8;
    
    // Generate a number from the full bytes. Then, prepend a smaller number
    // covering the remaining bits.
    var main = bytesToInt(nextBytes(fullBytes));
    var additional = dartRandom.nextInt(pow(2, remainingBits));
    return main + (new BigInt.from(additional) << (fullBytes * 8));
  }

  @override
  Uint8List nextBytes(int count) {
    var list = new Uint8List(count);

    for (var i = 0; i < list.length; i++) {
    	list[i] = nextUint8();
		}

		return list;
  }

  @override
  int nextUint16()  => dartRandom.nextInt(pow(2, 32));

  @override
  int nextUint32() => dartRandom.nextInt(pow(2, 32));

  @override
  int nextUint8() => dartRandom.nextInt(pow(2, 8));

  @override
  void seed(CipherParameters params) {
    // ignore, dartRandom will already be seeded if wanted
  }
}