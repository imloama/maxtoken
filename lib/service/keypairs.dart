import 'package:maxtoken/service/blockchain.dart';
import 'package:stellar/stellar.dart';

class KeyPairs{

  static KeyPairData random(BlockChainType type){
    if(type == BlockChainType.Stellar){
      KeyPair kp = KeyPair.random();
      return KeyPairData(
        publicKey: kp.accountId,
        secret: kp.secretSeed
      )
    }
  }

}

class KeyPairData{

  final String publicKey;
  final String secret;

  KeyPairData({this.publicKey, this.secret});


}