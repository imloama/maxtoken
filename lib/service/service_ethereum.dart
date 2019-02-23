import 'package:http/http.dart';
import 'package:maxtoken/model/account.dart';
import 'package:maxtoken/model/asset.dart';
import 'package:maxtoken/model/transaction.dart';
import 'package:web3dart/web3dart.dart' as web3dart;
import 'package:maxtoken/service/service.dart';
import 'package:hex/hex.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;

class EthereumService extends Service{

  String _apiUrl;
  web3dart.Web3Client _client;

  EthereumService._(String url){
    this._apiUrl = url;
    final http = Client();
    this._client = web3dart.Web3Client(this._apiUrl, http);
  }

  @override
  Future<Account> getBalance(String address) async{
    var ethereumAddress = web3dart.EthereumAddress(address);
    web3dart.EtherAmount balance = await this._client.getBalance(ethereumAddress);
    final nativeAsset = EthereumNativeAsset(balance.getInEther.toString());
    List<Asset> balances = [nativeAsset];
    final account = EthereumAccount(address, balances);
    //TODO 其他合约的资产
    return account;
  }

  @override
  Future<Transaction> getTransactionByHash(String hash) async {
    final tx = await this._client.getTransactionByHash(hash);
    EthereumTransaction transaction =EthereumTransaction();
    transaction.hash = hash;
    transaction.block = tx.blockNumber.blockNum.toString();
    transaction.gas = tx.gas;
    transaction.gasPrice = tx.gasPrice.getInEther.toInt();
    transaction.input = tx.input;

    return transaction;
  }

  @override
  Future<String> postTransaction(String target,String secret,int gas,Object amount) async{
    var credentials = web3dart.Credentials.fromPrivateKeyHex(secret);
    final transaction = new web3dart.Transaction(
      keys: credentials, maximumGas: gas
    );
    List<int> result = await transaction.prepareForSimpleTransaction(
      new web3dart.EthereumAddress(target), // your target address 
      web3dart.EtherAmount.fromUnitAndValue(web3dart.EtherUnit.finney, amount)
    ).send(this._client);
    return HEX.encode(result);
  }


  

}

class EthereumAddress extends Address{

  EthereumAddress.fromPublicAddress(String address) : super.fromMnemonic(address);
  EthereumAddress.fromSecret(String secret) : super.fromMnemonic(secret){
    //根据私钥生成公钥
     this.address = web3dart.Credentials.fromPrivateKeyHex(secret).address.hexEip55;
  }
  EthereumAddress.fromMnemonic(String mnemonic,[int index = 0]) : super.fromMnemonic(mnemonic){
    final seed = bip39.mnemonicToSeed(mnemonic); 
    final root = bip32.BIP32.fromSeed(seed);
    final path = root.derivePath("m/44'/60'/0'/0/$index");
    this.secret = HEX.encode(path.privateKey);
    this.address = web3dart.Credentials.fromPrivateKeyHex(this.secret).address.hexEip55;
  }
  
}