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

  List<String> _transaction= [];
  
  void addTransaction(String transaction) {
    _transaction.add('[${DateTime.now()}] $transaction');
  }

  void displayTransactionHistory() {
    print("\nTransaction history for $_accountNumber :");
    if (_transaction.isEmpty) {
      print("No transactions yet.");
    } else {
      for (var t in _transaction) {
        print("- $t");
      }
    }
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
    addTransaction('Withdraw -$amount');
  }

  @override
  void deposit(double amount) {
    balance += amount;
    print("Deposit of $amount successful. New balance: $balance");
    addTransaction( 'Deposit +$amount');
  }

  @override
  void applyInterest(){
    double interest = balance * _interestRate;
    balance += interest;
    print("Interest of $interest applied. New balance: $balance");
    addTransaction('Interest applied +$interest');
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
    addTransaction('Withdraw -$amount');
  }

  @override
  void deposit(double amount) {
    balance += amount;
    print("Deposit of $amount successful. New balance: $balance");
    addTransaction('Deposit +$amount');
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
    addTransaction('Withdraw -$amount'); 
  }

  @override
  void deposit(double amount) {
    balance += amount;
    print("Deposit of $amount successful. New balance: $balance");  
    addTransaction('Deposit +$amount');
  }

  @override
  void applyInterest(){
    double interest = balance * _interestRate;
    balance += interest;
    print("Interest of $interest applied. New balance: $balance");
    addTransaction('Interest applied +$interest');
  }
}

abstract class InterestBearing{
  void applyInterest();
}

class Bank{
  final List<BankAccount> _accounts = [];

  void addAccount(BankAccount account){
    _accounts.add(account);
    print("Account ${account.accountNumber} created for ${account.holderName}.");
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
    print("\nApplying monthly interest to all interest-bearing accounts...");
    for(var account in _accounts){
      if(account is InterestBearing){
        (account as InterestBearing).applyInterest();
      }
    }
  }

   void displayAllAccounts() {
    print( "\nAll Bank Accounts:");
    for (var acc in _accounts) {
      print('Account Number: ${acc.accountNumber}, Holder Name: ${acc.holderName}, Balance: ${acc.balance}');
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
    addTransaction('Withdraw -$amount');
  }

  @override
  void deposit(double amount) {
    if (balance + amount > _maxBalance) {
      print("Cannot deposit. Maximum balance of $_maxBalance exceeded.");
      return;
    }
    balance += amount;
    print("Deposit of $amount successful. New balance: $balance");
    addTransaction('Deposit +$amount');
  }
}


void main(){
  Bank bank = Bank();

  SavingsAccount savingsAccount = SavingsAccount(1001, "Alice", 1000.0);
  CheckingAccount checkingAccount = CheckingAccount(1002, "Bob", 500.0);
  PremiumAccount premiumAccount = PremiumAccount(1003, "Charlie", 11000.0);
  StudentAccount studentAccount = StudentAccount(1004, "David", 2000.0);

  bank.addAccount(savingsAccount);
  bank.addAccount(checkingAccount);
  bank.addAccount(premiumAccount);
  bank.addAccount(studentAccount);

  print("\nPerforming transactions for saving accounts:");
  savingsAccount.deposit(100.0);
  savingsAccount.withdraw(300.0);

  print("\nPerforming transactions for checking accounts:");
  checkingAccount.deposit(150.0);
  checkingAccount.withdraw(700.0);

  print("\nPerforming transactions for premium accounts:");
  premiumAccount.deposit(4000.0);
  premiumAccount.withdraw(3000.0);

  print("\nPerforming transactions for student accounts:");
  studentAccount.deposit(2500.0);
  studentAccount.withdraw(1000.0);  

  bank.applymonthlyInterest();

  print("\nTransferring money from savings account to checking account:");
  bank.transferMoney(1001, 1002, 200);
  
  savingsAccount.displayTransactionHistory();
  premiumAccount.displayTransactionHistory();
  checkingAccount.displayTransactionHistory();
  studentAccount.displayTransactionHistory();
  bank.displayAllAccounts();
}