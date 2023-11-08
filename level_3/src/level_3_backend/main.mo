import Principal "mo:base/Principal";
import Blob "mo:base/Blob";
import Nat "mo:base/Nat";
import TrieMap "mo:base/TrieMap";
import Hash "mo:base/Hash";
import Iter "mo:base/Iter";
import Text "mo:base/Text";
import Result "mo:base/Result";
import HashMap "mo:base/HashMap";

actor 
{
  
  type Account = {owner : Principal; subaccount : ?Blob;};

  // Define an equality function for Account
  func accountEqual(a1: Account, a2: Account) : Bool 
  {
    return Principal.equal(a1.owner, a2.owner) and
      (switch (a1.subaccount, a2.subaccount) 
      {
        case (null, null) true;
        case (?s1, ?s2) Blob.equal(s1, s2);
        case _ false;
      });
  };

  // Define a hash function for Account
  func accountHash(a: Account) : Nat {
    let ownerHash = Principal.hash(a.owner);
    let subaccountHash = switch (a.subaccount) {
      case (null) 0;
      case (?s) Blob.hash(s);
    };
    // Combine the hashes. This is a simplistic way to combine hash values.
    ownerHash + subaccountHash
  };

  var ledger : TrieMap.TrieMap<Account, Nat> = TrieMap.TrieMap<Account, Nat>(accountEqual, Account.hash);

  // To Do
  public query func name() : async Text {
    return "";
  };

  // To Do
  public query func symbol() : async Text {
    return "";
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
