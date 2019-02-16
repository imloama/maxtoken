


abstract class Address{
   //助记词
  String mnemonic = null;
  int index = 0;
  //公钥
  String address = null;
  //私钥
  String secret = null;

  Address.fromPublicAddress(String address){
    this.address = address;
  }

  Address.fromSecret(String secret){
    this.secret = secret;
  }

  Address.fromMnemonic(String mnemonic,[int index = 0]){
    this.mnemonic = mnemonic;
    this.index = index;
  }


}