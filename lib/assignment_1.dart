abstract class BankAccount{
  int _accountNumber;
  double _balance;  
  String _holderName;

  BankAccount(this._accountNumber, this._holderName, this._balance);

  void withdraw(double amount);
  void deposit(double amount);

  int get accountNumber{
    return _accountNumber;
  }

  set accountNumber(int number){
    _accountNumber = number;
  }
  
  String get holderName{
    return _holderName;
  }

  set holderName(String name){
    _holderName = name;
  } 

  double get balance{
    return _balance; 
  }

  set balance(double amount){
      _balance = amount;
  }

  void displayAccountInfo(){
    print("Account Number: $_accountNumber");
    print("Holder Name: $_holderName");
    print("Balance: $_balance");
  }
}

// SavingsAccount class extending BankAccount
class SavingsAccount extends BankAccount implements InterestBearing{
  static const double _minimumBalance = 500.0;
  static const double _interestRate = 0.02;
  int _withdrawalCount = 0;

  SavingsAccount(super.accountNumber, super.holderName, super.balance);

  @override
  void withdraw(double amount) {
    if(_withdrawalCount >=3){
      print("Withdrawal limit reached for this month.");
      return;
    }
    if(balance - amount < _minimumBalance){
      print("Cannot withdraw. Minimum balance requirement not met.");
      return;
    }
    balance -= amount;
    _withdrawalCount++;
    print("Withdrawal of $amount successful. New balance: $balance");
  }
  @override
  void deposit(double amount) {
    balance += amount;
    print("Deposit of $amount successful. New balance: $balance");
  }
  @override
  void applyInterest(){
    double interest = balance * _interestRate;
    balance += interest;
    print("Interest of $interest applied. New balance: $balance");
  }
}

// CheckingAccount class extending BankAccount
class CheckingAccount extends BankAccount{
  static const double _overdraftFee = 35.0;

  CheckingAccount(super.accountNumber, super.holderName, super.balance);

  @override
  void withdraw(double amount) {
    double newBalance = balance - amount;
    if(newBalance <0){
      print("Overdraft! An overdraft fee of $_overdraftFee will be applied.");
      super.balance = newBalance-_overdraftFee;
      print("New balance after overdraft fee: $balance");
    }else{
      balance = newBalance;
      print("Withdrawal of $amount successful. New balance: $balance");
    }
  }

  @override
  void deposit(double amount) {
    balance += amount;
    print("Deposit of $amount successful. New balance: $balance");
  }  

}

// PremiumAccount class extending BankAccount
class PremiumAccount extends BankAccount implements InterestBearing{
  static const double _minimumBalance = 10000.0;
  static const double _interestRate = 0.05;
  PremiumAccount(super.accountNumber, super.holderName, super.balance);
  @override
  void withdraw(double amount) {
    if(balance - amount < _minimumBalance){
      print("Cannot withdraw. Minimum balance requirement not met.");
      return;       
    }
    balance -= amount;
    print("Withdrawal of $amount successful. New balance: $balance");   
  }
  @override
  void deposit(double amount) {
    balance += amount;
    print("Deposit of $amount successful. New balance: $balance");  
  }
  @override
  void applyInterest(){
    double interest = balance * _interestRate;
    balance += interest;
    print("Interest of $interest applied. New balance: $balance");
  }
}

abstract class InterestBearing{
  void applyInterest();
}

class Bank{
  final List<BankAccount> _accounts = [];

  void addAccount(BankAccount account){
    _accounts.add(account);
    print("Account added: ${account.accountNumber}");
  }
  void findAccount(int accountNumber){
    for(var account in _accounts){
      if(account.accountNumber == accountNumber){
        account.displayAccountInfo();
        return;
      }
    }
    print("Account not found.");
  }

  void transferMoney(int fromAccountNumber, int toAccountNumber, double amount){
    BankAccount? fromAccount;
    BankAccount? toAccount;

    for(var account in _accounts){
      if(account.accountNumber == fromAccountNumber){
        fromAccount = account;
      }
      if(account.accountNumber == toAccountNumber){
        toAccount = account;
      }
    }

    if(fromAccount == null || toAccount == null){
      print("One or both accounts not found.");
      return;
    }

    fromAccount.withdraw(amount);
    toAccount.deposit(amount);
    print("Transfer of $amount from account $fromAccountNumber to account $toAccountNumber completed.");
  }

  void applymonthlyInterest(){
    for(var account in _accounts){
      if(account is InterestBearing){
        (account as InterestBearing).applyInterest();
      }
    }
  }

  List <String> transactionHistory = [];
  void recordTransaction(String transaction){
    transactionHistory.add("${DateTime.now()}: $transaction");
  }
  void displayTransactionHistory(){
    print("Transaction History:");
    for(var transaction in transactionHistory){
      print(transaction);
    }
  }
}

class StudentAccount extends BankAccount {
  static const double _maxBalance = 5000.0;

  StudentAccount(super.accountNumber, super.holderName, super.balance);

  @override
  void withdraw(double amount) {
    if (balance - amount < 0) {
      print("Insufficient balance.");
      return;
    }
    balance -= amount;
    print("Withdrawal of $amount successful. New balance: $balance");
  }

  @override
  void deposit(double amount) {
    if (balance + amount > _maxBalance) {
      print("Cannot deposit. Maximum balance of $_maxBalance exceeded.");
      return;
    }
    balance += amount;
    print("Deposit of $amount successful. New balance: $balance");
  }
}


void main(){
  Bank bank = Bank();

  SavingsAccount savingsAccount = SavingsAccount(1001, "Alice", 1000.0);
  CheckingAccount checkingAccount = CheckingAccount(1002, "Bob", 500.0);
  PremiumAccount premiumAccount = PremiumAccount(1003, "Charlie", 11000.0);

  bank.addAccount(savingsAccount);
  bank.addAccount(checkingAccount);
  bank.addAccount(premiumAccount);

  savingsAccount.deposit(100.0);
  savingsAccount.withdraw(300.0);

  checkingAccount.deposit(150.0);
  checkingAccount.withdraw(700.0);

  premiumAccount.deposit(4000.0);
  premiumAccount.withdraw(3000.0);

  bank.applymonthlyInterest();
}