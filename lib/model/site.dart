

class Site{

  // btc api site
  String btcSite = BLOCKCHAIN_INFO;
  bool isBtcTest = false;

  // eth api site
  String ethSite = ETHERSCAN;
  bool isEthTest = false;

  // stellar horizon api site
  String xlmSite = HORIZON;
  bool isXlmTest = false;

  Site({this.btcSite,this.ethSite,this.xlmSite});


  static const String BLOCKCHAIN_INFO = "https://blockchain.info";
  static const String BLOCKCHAIN_INFO_TEST = "https://testnet.blockchain.info";

  static const String ETHERSCAN = "https://api.etherscan.io/api";
  static const String ETHERSCAN_TEST = "https://api-rinkeby.etherscan.io/api";

  static const String HORIZON = "https://horizon.stellar.org";
  static const String HORIZON_TEST = "https://horizon-testnet.stellar.org";


}