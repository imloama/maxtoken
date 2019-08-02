import 'package:flutter_test/flutter_test.dart';
// import 'package:stellar_hd_wallet/stellar_hd_wallet.dart';
import 'package:maxtoken/hdwallet/hdwallet.dart';
import 'package:maxtoken/hdwallet/kp.dart';
// import 'package:maxtoken/hdwallet/ed25519.dart' as ed25519;
import "package:ed25519_hd_key/ed25519_hd_key.dart" as ed25519;
import 'package:tweetnacl/tweetnacl.dart' as ED25519;
import 'package:hex/hex.dart';
import 'dart:typed_data';

/*
void main() {
  test('get account id from mnemonic', () {
    final mnemonic =
        "illness spike retreat truth genius clock brain pass fit cave bargain toe";
    final wallet = StellarHDWallet.fromMnemonic(mnemonic);
    final keypair = wallet.getKeyPair();
    expect(keypair.accountId,
        "GDRXE2BQUC3AZNPVFSCEZ76NJ3WWL25FYFK6RGZGIEKWE4SOOHSUJUJ6");
    expect(wallet.getSecretSeed(),
        "SBGWSG6BTNCKCOB3DIFBGCVMUPQFYPA2G4O34RMTB343OYPXU5DJDVMN");
    // expect(wallet.getAccountId(index: 1),
    //     "GBAW5XGWORWVFE2XTJYDTLDHXTY2Q2MO73HYCGB3XMFMQ562Q2W2GJQX");
    // expect(wallet.getSecretSeed(index: 1),
    //     "SCEPFFWGAG5P2VX5DHIYK3XEMZYLTYWIPWYEKXFHSK25RVMIUNJ7CTIS");
  });
}
*/
void main(){
  final mnemonic =
        "illness spike retreat truth genius clock brain pass fit cave bargain toe";
    final wallet = StellarHDWallet.fromMnemonic(mnemonic);
    final seedhex = HEX.encode(wallet.seed);
    final key = wallet.derivePath("m/44'/148'/0'");
    final seedlist = key.sublist(0,32);
    final pathhex = HEX.encode(seedlist);
    final keypair = KeyPair.fromSecretSeedList(seedlist);
    
    // final keypair = wallet.getKeyPair();
    final pubkeyhex = HEX.encode(keypair.publicKey);
    final prikeyhex = HEX.encode(keypair.privateKey);
    print("seedhex:"+seedhex);
    print("pathhex:"+pathhex);
    print("pubkeyhex:" + pubkeyhex);
    print("prikeyhex:" + prikeyhex);
    print("strkey accountid:" + StrKey.encodeStellarAccountId(keypair.publicKey));
    

    // edd25519.ED25519_HD_KEY.getMasterKeyFromSeed(seedhex);
    ed25519.KeyData kdata = ed25519.ED25519_HD_KEY.derivePath("m/44'/148'/0'", seedhex);
    print("seed hex:" + HEX.encode(kdata.key.sublist(0,32)));
    final pb = ed25519.ED25519_HD_KEY.getBublickKey(kdata.key.sublist(0,32), false);
    print("str accountid: " + StrKey.encodeStellarAccountId(pb));

    final signature = ED25519.Signature.keyPair_fromSeed(kdata.key.sublist(0,32));
    print("pubkey hex:" + HEX.encode(signature.publicKey));


    /*
    final ekp = new ed25519.KeyPair(32, 64);
    Uint8List pk = ekp.publicKey;
    Uint8List sk = ekp.secretKey;
     for (int i = 0; i < 32; i++) {
      sk[i] = seedlist[i];
    }
    final result = ed25519.TweetNaclFast.crypto_sign_keypair(pk, sk, true);
    print("pkhex:" + HEX.encode(pk));
    print("skhex:" + HEX.encode(sk));
    print("result：" + result.toString());
    */


    

    /*
    expect(keypair.accountId,
        "GDRXE2BQUC3AZNPVFSCEZ76NJ3WWL25FYFK6RGZGIEKWE4SOOHSUJUJ6");
        */
}