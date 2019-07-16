import 'package:flutter_test/flutter_test.dart';
// import 'package:stellar_hd_wallet/stellar_hd_wallet.dart';
import 'package:maxtoken/hdwallet/hdwallet.dart';
import 'package:hex/hex.dart';
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
    final pathhex = HEX.encode(wallet.derivePath("m/44'/148'/0'").sublist(0,32));
    print(seedhex);
    print(pathhex);
    final keypair = wallet.getKeyPair();
    final pubkeyhex = HEX.encode(keypair.publicKey);
    print("pubkeyhex:" + pubkeyhex);
    print("prikeyhex:" + HEX.encode(keypair.privateKey));
    

    /*
    expect(keypair.accountId,
        "GDRXE2BQUC3AZNPVFSCEZ76NJ3WWL25FYFK6RGZGIEKWE4SOOHSUJUJ6");
        */
}