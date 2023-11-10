import Principal "mo:base/Principal";
import Blob "mo:base/Blob";
import Nat "mo:base/Nat";
import TrieMap "mo:base/TrieMap";
import Hash "mo:base/Hash";
import Iter "mo:base/Iter";
import Text "mo:base/Text";
import Result "mo:base/Result";
import HashMap "mo:base/HashMap";
import Option "mo:base/Option";
import Account "account";

actor 
{
  
  type Account = {owner : Principal; subaccount : ?Blob;};

  var ledger : TrieMap.TrieMap<Account, Nat> = TrieMap.TrieMap<Account, Nat>(Account.accountsEqual, Account.accountsHash);

  public query func name() : async Text {
    return "Wisecoin";
  };

  public query func symbol() : async Text {
    return "WSC";
  };

  public func mint(principal : Principal, amount : Nat) : async () {
    let mintAccount : Account = {
      owner = principal;
      subaccount = null;
    };

    let currentBalance : Nat = switch(ledger.get(mintAccount)) {
      case(null) { 0 };      
      case(?balance) { balance };
    };

    let newAmount : Nat = currentBalance + amount;

    ledger.put(mintAccount , newAmount);
    return ();
  };

  public func transfer(from : Account, to : Account, amount : Nat) : async Result.Result<(), Text> {

    let fromBalance : Nat = switch(ledger.get(from)) {
      case(null) { 0 };      
      case(?balance) { balance };
    };

    let toBalance: Nat = switch(ledger.get(to)) {
      case(null) { 0 };      
      case(?balance) { balance };
    };

    if (fromBalance < amount) {
      return #err("Insufficient balance")
    } else {
      ledger.put(from, fromBalance - amount) ;
      ledger.put(to, toBalance + amount);
      return #ok();
    };
  };

  public query func balanceOf(account : Account) : async Nat {
    return Option.get(ledger.get(account), 0);
  };

  // To Do
  public query func totalSupply() : async Nat {
    var sum : Nat = 0;
    for (balance in ledger.vals()) {
      sum += balance;
    };
    return sum;
  };

};
