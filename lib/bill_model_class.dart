class Bill {
  String companyName;
  String address;
  String manager;
  String accountNumber;
  double amount;
  DateTime transactionDate;
  String transactionType;
  double taxRate;

  Bill({
    required this.companyName,
    required this.address,
    required this.manager,
    required this.accountNumber,
    required this.amount,
    required this.transactionDate,
    required this.transactionType,
    this.taxRate = 0.08,
  });

  double get tax {
    return amount * taxRate;
  }

  double get grandTotal {
    return amount + tax;
  }
}
