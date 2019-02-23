
class Transaction{
  String hash;
  String block;
 
}

class StellarTransaction extends Transaction {
  String hash;
  int ledger;
  String createdAt;
  String sourceAccount;
  String pagingToken;
  int sourceAccountSequence;
  int feePaid;
  int operationCount;
  String envelopeXdr;
  String resultXdr;
  String resultMetaXdr;
  String memoType;
  String memo;
}

class EthereumTransaction extends Transaction{
  int gas;
	int gasPrice;
	List<int> input;
	String value;
}