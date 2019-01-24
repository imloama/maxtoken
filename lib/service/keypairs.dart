import 'package:maxtoken/service/blockchain.dart';
import 'package:stellar/stellar.dart';
import 'package:bip39/bip39.dart' as bip39;


class KeyPairs{

  static KeyPairData random(BlockChainType type){
    switch(type){
      case BlockChainType.Stellar:
        return _randomForStellar();
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

  static Future<KeyPairData> _randomForStellar() async {
      //KeyPair kp = KeyPair.random();
      String randomMnemonic = await bip39.generateMnemonic();
      String seed = bip39.mnemonicToSeedHex(randomMnemonic);
      //ed25519-hd-key

      return KeyPairData(
        publicKey: kp.accountId,
        secret: kp.secretSeed
      );
  }

  static Future<KeyPairData> _randomForBitcoin() async {
    // Only support BIP39 English word list
    // uses HEX strings for entropy
    String randomMnemonic = await bip39.generateMnemonic();
    String seed = bip39.mnemonicToSeedHex(randomMnemonic);


  }

}

class KeyPairData{
  final String mnemonic;
  final String publicKey;
  final String secret;

  KeyPairData({this.mnemonic,this.publicKey, this.secret});


}