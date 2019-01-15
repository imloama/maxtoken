
class Wallet {

  String name;
  String pubkey;//公钥
  BlockChainType chain;

  Wallet({this.name, this.pubkey, this.chain});

  

}

enum BlockChainType {
  BitCoin,// 0
  Etherum,// 1
  Stellar,//2
  EOS,//3
  Ripple//4
}