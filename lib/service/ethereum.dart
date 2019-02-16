import 'package:web3dart/web3dart.dart';
import 'package:web3dart/src/wallet/credential.dart';
import 'package:maxtoken/service/service.dart';
import 'package:hex/hex.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;

class EthereumService {


  

}

class EthereumAddress extends Address{

  EthereumAddress.fromPublicAddress(String address) : super.fromMnemonic(address);
  EthereumAddress.fromSecret(String secret) : super.fromMnemonic(secret){
    //根据私钥生成公钥
     this.address = Credentials.fromPrivateKeyHex(secret).address.hexEip55;
  }
  EthereumAddress.fromMnemonic(String mnemonic,[int index = 0]) : super.fromMnemonic(mnemonic){
    final seed = bip39.mnemonicToSeed(mnemonic); 
    final root = bip32.BIP32.fromSeed(seed);
    final path = root.derivePath("m/44'/60'/0'/0/$index");
    this.secret = HEX.encode(path.privateKey);
    this.address = Credentials.fromPrivateKeyHex(this.secret).address.hexEip55;
  }
}