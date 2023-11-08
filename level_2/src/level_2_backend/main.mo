import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Result "mo:base/Result";
import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";


actor 
{
  
  public type Member = {name: Text; age: Nat;};

  var members : HashMap.HashMap<Principal, Member> =  HashMap.HashMap<Principal, Member>(0, Principal.equal, Principal.hash);

  public shared ({ caller }) func addMember(member : Member) : async Result.Result<(), Text> 
  {
    switch (members.get(caller)) 
    {
      case(null) 
      {
        members.put(caller, member);
        return #ok();
      };
      case(? member) 
      {
        return #err("There is already a member for that identity.");
      };
    };
  };
  
  public query func getMember(principal : Principal) : async Result.Result<Member, Text>  
  {
    switch (members.get(principal)) 
    {
      case(null) 
      {
        return #err("Caller is not a member");
      };
      case(? member) 
      {
        return #ok(member); 
      };
    };
    
  };

  public shared ({ caller }) func updateMember(newMember: Member) : async Result.Result<(), Text> 
  {
    switch (members.get(caller)) 
    {
      case(null) 
      {
        return #err("Caller is not a member");
      };
      case(? member) 
      {
        members.put(caller, newMember);
        return #ok();
      };
    };
  };

  public query func getAllMembers() : async [Member] 
  {

    let iter = members.vals();
    // let value = iter.next();
    // Debug.print(debug_show(value));
    // return [];
    return Iter.toArray(iter);

  };

  public query func numberOfMembers() : async Nat 
  {
    return members.size();
  };

  public shared ({ caller }) func removeMember(principal: Principal) : async Result.Result<(), Text> 
  {
    switch (members.get(caller)) 
    {
      case(null) 
      {
        return #err("Caller is not a member");
      };
      case(? member) 
      {
        members.delete(caller);
        return #ok();
      };
    };
  };

};
