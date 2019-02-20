
class Transaction{
  String hash;
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