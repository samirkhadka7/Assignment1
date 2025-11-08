abstract class BankAccount {
  // Encapsulated fields
  String accountNumber;
  String accountHolder;
  double balance;

  // Constructor using named parameters
  BankAccount({
    required this.accountNumber,
    required this.accountHolder,
    required this.balance,
  });

  // Abstract methods
  void deposit(double amount);
  void withdraw(double amount);

  // Concrete method
  void displayInfo() {
  print("Account Number: $accountNumber");
  print("Account Holder: $accountHolder");
  print("Balance: $balance");
  }

}




// Abstract class for interest-bearing accounts
abstract class InterestBearing {
  double calculateInterest();
}
// Savings Account
class SavingsAccount extends BankAccount implements InterestBearing {
  int _withdrawCount = 0;
  final int _withdrawLimit = 3;
  SavingsAccount({
    required super.accountNumber,
    required super.accountHolder,
    required super.balance,
  });
  @override
  void deposit(double amount) {
    balance += amount;
    print("Deposited $amount to Savings Account.");
  }
  @override
  void withdraw(double amount) {
    if (_withdrawCount >= _withdrawLimit) {
      print("Withdrawal limit reached!");
      return;
    }
    if (balance - amount < 500) {
      print("Cannot go below minimum balance of 500.");
      return;
    }
    balance -= amount;
    _withdrawCount++;
    print("Withdrawn $amount from Savings Account.");
  }

  @override
  double calculateInterest() {
    return balance * 0.02;
  }
}



// Checking Account
class CheckingAccount extends BankAccount {
  CheckingAccount({
    required super.accountNumber,
    required super.accountHolder,
    required super.balance,
  });

  @override
  void deposit(double amount) {
    balance += amount;
    print("Deposited $amount to Checking Account.");
  }

  @override
  void withdraw(double amount) {
    balance -= amount;
    if (balance < 0) {
      balance -= 35;
      print("Overdraft! 35 fee charged.");
    }
    print("Withdrawn $amount from Checking Account.");
  }
}

// Premium Account
class PremiumAccount extends BankAccount implements InterestBearing {
  PremiumAccount({
    required super.accountNumber,
    required super.accountHolder,
    required super.balance,
  });

  @override
  void deposit(double amount) {
    balance += amount;
    print("Deposited $amount to Premium Account.");
  }


  @override
  void withdraw(double amount) {
    if (balance - amount < 10000) {
      print("Cannot go below minimum balance of 1000.");
      return;
    }
    balance -= amount;
    print("Withdrawn $amount from Premium Account.");
  }

  @override
  double calculateInterest() {
    return balance * 0.05;
  }
}

// Student Account
class StudentAccount extends BankAccount {
  StudentAccount({
    required super.accountNumber,
    required super.accountHolder,
    required super.balance,
  });

  @override
  void deposit(double amount) {
    if (balance + amount > 500) {
      print("Cannot exceed maximum balance of 500.");
      return;
    }
    balance += amount;
    print("Deposited $amount to Student Account.");
  }

  @override
  void withdraw(double amount) {
    if (balance - amount < 0) {
      print("Insufficient balance.");
      return;
    }
    balance -= amount;
    print("Withdrawn $amount from Student Account.");
  }
}

// Bank class
class Bank {
  List<BankAccount> accounts = [];

  void addAccount(BankAccount account) {
    accounts.add(account);
  }

  BankAccount? findAccount(String number) {
    for (var acc in accounts) {
      if (acc.accountNumber == number) {
        return acc;
      }
    }
    return null;
  }

  void transfer(String from, String to, double amount) {
    var sender = findAccount(from);
    var receiver = findAccount(to);

    if (sender == null || receiver == null) {
      print("Account not found!");
      return;
    }

    sender.withdraw(amount);
    receiver.deposit(amount);
    print("Transferred $amount from ${sender.accountHolder} to ${receiver.accountHolder}");
  }

  void applyMonthlyInterest() {
    for (var acc in accounts) {
      if (acc is InterestBearing) {
        final interest = (acc as InterestBearing).calculateInterest();
        acc.deposit(interest);
        print("Interest $interest added to ${acc.accountHolder}");
      }
    }
  }

  void showAllAccounts() {
    for (var acc in accounts) {
      acc.displayInfo();
      print("------");
    }
  }
}

// Main function
void main() {
  Bank bank = Bank();

  bank.addAccount(SavingsAccount(accountNumber: "001", accountHolder: "Samir", balance: 1000));
  bank.addAccount(CheckingAccount(accountNumber: "002", accountHolder: "Hari", balance: 300));
  bank.addAccount(PremiumAccount(accountNumber: "003", accountHolder: "Sita", balance: 15000));
  bank.addAccount(StudentAccount(accountNumber: "004", accountHolder: "Rita", balance: 1000));

  bank.showAllAccounts();
  bank.transfer("001", "002", 200);
  bank.applyMonthlyInterest();
}