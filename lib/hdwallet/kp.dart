// import 'package:tweetnacl/tweetnacl.dart' as ed25519;
import 'package:maxtoken/hdwallet/ed25519.dart' as ed25519;
import 'dart:typed_data';
import 'package:fixnum/fixnum.dart' as fixNum;
import "package:stellar/src/base32.dart";
import 'package:collection/collection.dart';

Function eq = const ListEquality().equals;

class VersionByte {
  final _value;
  const VersionByte._internal(this._value);
  toString() => 'VersionByte.$_value';
  VersionByte(this._value);
  getValue() => this._value;

  static const ACCOUNT_ID = const VersionByte._internal((6 << 3)); // G
  static const SEED = const VersionByte._internal((18 << 3)); // S
  static const PRE_AUTH_TX = const VersionByte._internal((19 << 3)); // T
  static const SHA256_HASH = const VersionByte._internal((23 << 3)); // X

}

class StrKey {
  static String encodeStellarAccountId(Uint8List data) {
    return encodeCheck(VersionByte.ACCOUNT_ID, data);
  }

  static Uint8List decodeStellarAccountId(String data) {
    return decodeCheck(VersionByte.ACCOUNT_ID, data);
  }

  static String encodeStellarSecretSeed(Uint8List data) {
    return encodeCheck(VersionByte.SEED, data);
  }

  static Uint8List decodeStellarSecretSeed(String data) {
    return decodeCheck(VersionByte.SEED, data);
  }

  static String encodePreAuthTx(Uint8List data) {
    return encodeCheck(VersionByte.PRE_AUTH_TX, data);
  }

  static Uint8List decodePreAuthTx(String data) {
    return decodeCheck(VersionByte.PRE_AUTH_TX, data);
  }

  static String encodeSha256Hash(Uint8List data) {
    return encodeCheck(VersionByte.SHA256_HASH, data);
  }

  static Uint8List decodeSha256Hash(String data) {
    return decodeCheck(VersionByte.SHA256_HASH, data);
  }

  static String encodeCheck(VersionByte versionByte, Uint8List data) {
    List<int> output = List();
    output.add(versionByte.getValue());
    output.addAll(data);

    Uint8List payload = Uint8List.fromList(output);
    Uint8List checksum = StrKey.calculateChecksum(payload);
    output.addAll(checksum);
    Uint8List unencoded = Uint8List.fromList(output);

    String charsEncoded = base32.encode(unencoded);

    return charsEncoded;
  }

  static Uint8List decodeCheck(VersionByte versionByte, String encData) {
    Uint8List decoded = base32.decode(encData);
    int decodedVersionByte = decoded[0];
    Uint8List payload =
        Uint8List.fromList(decoded.getRange(0, decoded.length - 2).toList());
    Uint8List data =
        Uint8List.fromList(payload.getRange(1, payload.length).toList());
    Uint8List checksum = Uint8List.fromList(
        decoded.getRange(decoded.length - 2, decoded.length).toList());

    if (decodedVersionByte != versionByte.getValue()) {
      throw new FormatException("Version byte is invalid");
    }

    Uint8List expectedChecksum = StrKey.calculateChecksum(payload);

    if (!eq(expectedChecksum, checksum)) {
      throw new FormatException("Checksum invalid");
    }

    return data;
  }

  static Uint8List calculateChecksum(Uint8List bytes) {
// This code calculates CRC16-XModem checksum
// Ported from https://github.com/alexgorbatchev/node-crc
    fixNum.Int32 crc = fixNum.Int32(0x0000);
    int count = bytes.length;
    int i = 0;
    fixNum.Int32 code;

    while (count > 0) {
      code = crc.shiftRightUnsigned(8) & 0xFF;
      code ^= bytes[i++] & 0xFF;
      code ^= code.shiftRightUnsigned(4);
      crc = crc << 8 & 0xFFFF;
      crc ^= code;
      code = code << 5 & 0xFFFF;
      crc ^= code;
      code = code << 7 & 0xFFFF;
      crc ^= code;
      count--;
    }

// little-endian
    return Uint8List.fromList([crc.toInt(), crc.shiftRightUnsigned(8).toInt()]);
  }
}
class KeyPair {
  Uint8List _mPublicKey = null;
  Uint8List _mPrivateKey = null;
  static Uint8List _mPrivateKey_seed = null;

  ///Creates a new KeyPair from the given public and private keys.
  KeyPair(Uint8List publicKey, Uint8List privateKey) {
    _mPublicKey = publicKey;
    _mPrivateKey = privateKey;
  }

  ///Returns true if this Keypair is capable of signing
  bool canSign() {
    return _mPrivateKey != null;
  }


  ///Creates a new Stellar keypair from a raw 32 byte secret seed.
  static KeyPair fromSecretSeedList(Uint8List seed) {
    _mPrivateKey_seed = seed;
    ed25519.KeyPair kp = ed25519.Signature.keyPair_fromSeed(seed);
    print("secretKey: \"${ed25519.TweetNaclFast.hexEncodeToString(kp.secretKey)}\"");
    print("publicKey: \"${ed25519.TweetNaclFast.hexEncodeToString(kp.publicKey)}\"");
    return new KeyPair(kp.publicKey, kp.secretKey);
  }

  ///Returns the human readable account ID encoded in strkey.
  String get accountId => StrKey.encodeStellarAccountId(_mPublicKey);

  ///Returns the human readable secret seed encoded in strkey.
  String get secretSeed => StrKey.encodeStellarSecretSeed(_mPrivateKey_seed);

  Uint8List get publicKey => _mPublicKey;

  Uint8List get privateKey => _mPrivateKey;

  ///Verify the provided data and signature match this keypair's public key.
  bool verify(Uint8List data, Uint8List signature) {
    ed25519.Signature sgr = ed25519.Signature(_mPublicKey, null);
    return sgr.detached_verify(data, signature);
  }
}