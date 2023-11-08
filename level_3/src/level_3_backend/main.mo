import Principal "mo:base/Principal";
import Blob "mo:base/Blob";
import Nat "mo:base/Nat";
import TrieMap "mo:base/TrieMap";
import Hash "mo:base/Hash";
import Iter "mo:base/Iter";
import Text "mo:base/Text";
import Result "mo:base/Result";
import HashMap "mo:base/HashMap";
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

  // To Do
  public func mint(principal : Principal, nat : Nat) : async () {
    
    return ();
  };

  // To Do
  // public shared ({ caller }) func transfer(from : Account, to : Account, amount : Nat) : async Result.Result<(), Text> {
  //   switch(ledger.get(caller)) {
  //     case(null) { return #ok() };
  //     case(?amount) { return "Caller does not have enough tokens in its main account." };
  //   };
  // };

  // To Do
  public func balanceOf(account : Account) : async Nat {
    return 0;
  };

  // To Do
  public query func totalSupply() : async Nat {
    return 0;
  };

};
