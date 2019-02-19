import 'package:maxtoken/model/asset.dart';
import 'package:maxtoken/service/service.dart';
import 'package:stellar/stellar.dart' as stellar;
import 'package:stellar_hd_wallet/stellar_hd_wallet.dart';
import 'package:maxtoken/model/asset.dart';
import 'package:maxtoken/model/account.dart';

/// 恒生服务功能
class StellarService extends Service{

  String _horizon;
  stellar.Server _server;

  StellarService._(String horizon){
    if(horizon == null){
      this._horizon = "https://horizon-testnet.stellar.org";
      stellar.Network.useTestNetwork();
    }else if(horizon.indexOf("testnet") > 0){
      this._horizon =horizon;
      stellar.Network.useTestNetwork();
    }else{
      this._horizon =horizon;
      stellar.Network.usePublicNetwork();
    }
    this._server = new stellar.Server(this._horizon);
    
  }

  @override
  Future<Account> getBalance(String address) async {
    final kp =stellar.KeyPair.fromAccountId(address);
    final account = await this._server.accounts.account(kp);
    final balances = account.balances;
    List<Asset> assets =List();
    balances.forEach((b){
      String code = null,issuer=null,host=null;
      bool isNative = false;
      if(b.assetCode!=null){
        code = 'XLM';
        host = 'stellar.org';
        isNative = true;
      }else{
        code = b.assetCode;
        issuer = b.assetIssuer.accountId;
      }
      final asset = StellarAsset(code,issuer,host,isNative,b.balance);
      asset.limit = b.limit;
      asset.buyingLiabilities = b.buyingLiabilities;
      asset.sellingLiabilities = b.sellingLiabilities;
      asset.assetType = b.assetType;
      assets.add(asset);
    });
    final result = StellarAccount(address, assets);
    result.sequenceNumber = account.sequenceNumber;
    result.subentryCount = account.subentryCount;
    result.inflationDestination = account.inflationDestination;
    result.thresholds = {
      "low_threshold": account.thresholds.lowThreshold,
      "med_threshold": account.thresholds.medThreshold,
      "high_threshold": account.thresholds.medThreshold,
    };
    result.flags = {
      "auth_required": account.flags.authRequired,
      "auth_revocable": account.flags.authRevocable,
      "auth_immutable": account.flags.authImmutable
    };
    return result;
  }

  
}

/// 恒星地址服务
class StellarAddress extends Address{

  stellar.KeyPair _keypair;

  StellarAddress.fromPublicAddress(String address) : super.fromMnemonic(address);
  StellarAddress.fromSecret(String secret) : super.fromMnemonic(secret){
    //根据私钥生成公钥
    this._keypair = stellar.KeyPair.fromSecretSeed(secret);
    this.address = this._keypair.accountId;
  }
  StellarAddress.fromMnemonic(String mnemonic,[int index = 0]) : super.fromMnemonic(mnemonic){
    final wallet = StellarHDWallet.fromMnemonic(mnemonic);
    this._keypair = wallet.getKeyPair(index: index);
    this.address = this._keypair.accountId;
    this.secret = this._keypair.secretSeed;
  }

  stellar.KeyPair get keypair => _keypair;

}