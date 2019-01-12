
class Wallet {

  String name;
  String pubkey;//公钥
  BlockChainType chain;

  Wallet({this.name, this.pubkey, this.chain});

  

}

enum BlockChainType {
  BitCoin,
  Etherum,
  Stellar,
  EOS,
  Ripple
}