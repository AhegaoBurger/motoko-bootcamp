import Result "mo:base/Result";
import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";
import Buffer "mo:base/Buffer";
import TrieMap "mo:base/TrieMap";
import Iter "mo:base/Iter";
import Option "mo:base/Option";
import Account "account";
import Http "http";

actor {
  ///////////////
  // LEVEL #1 //
  /////////////

  let daoName: Text = "WiseTech";

  var manifesto: Text = "Harnessing Collective Wisdom for Technological Empowerment.";
  
  public query func getName() : async Text {
    return daoName;
  };

  public query func getManifesto() : async Text {
    return manifesto;
  };

  public func setManifesto(newManifesto : Text) : async () {
    manifesto := newManifesto;
  };

  let goals = Buffer.Buffer<Text>(10);

  public func addGoal(newGoal : Text) : async () {
    goals.add(newGoal);
  };

  // public func getGoals() : async [Text] {
  //   return Iter.toArray(goals.vals());
  // };

  public func getGoals() : async [Text] {
    return Buffer.toArray(goals);
  };

  ///////////////
  // LEVEL #2 //
  /////////////
  public type Result<A, B> = Result.Result<A, B>;
  public type HashMap<A, B> = HashMap.HashMap<A, B>;

  public type Member = {daoName: Text; age: Nat;};

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

  ///////////////
  // LEVEL #3 //
  /////////////
  // For this level make sure to use the helpers function in Account.mo

  type Account = {owner : Principal; subaccount : ?Blob;};

  var ledger : TrieMap.TrieMap<Account, Nat> = TrieMap.TrieMap<Account, Nat>(Account.accountsEqual, Account.accountsHash);

  public query func coinName() : async Text {
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

    ///////////////
    // LEVEL #4 //
    /////////////
    // For this level you need to make use of the code implemented in Level 3

    public type Status = {
        #Open;
        #Accepted;
        #Rejected;
    };

    public type Proposal = {
        id : Nat;
        status : Status;
        manifest : Text;
        votes : Int;
        voters : [Principal];
    };

    public type createProposalOk = {
        #ProposalCreated : Nat;
    };

    public type createProposalErr = {
        #NotDAOMember;
        #NotEnoughTokens;
    };

    public type voteOk = {
        #ProposalAccepted;
        #ProposalRefused;
        #ProposalOpen;
    };

    public type voteErr = {
        #ProposalNotFound;
        #AlreadyVoted;
        #ProposalEnded;
    };

    public type voteResult = Result<voteOk, voteErr>;

    public type createProposalResult = Result<createProposalOk, createProposalErr>;

    // public shared ({ caller }) func createProposal(manifest : Text) : async createProposalResult {

    // };

    // public query func getProposal(id : Nat) : async ?Proposal {

    // };

    // public shared ({ caller }) func vote(id : Nat, vote : Bool) : async voteResult {

    // };
    ///////////////
    // LEVEL #5 //
    /////////////
    // If you want to insert your SVG as text in Motoko, make sure to replace all double quotes within the SVG code with single quotes.
    // This is necessary because Motoko use double quotes as delimiters.

    public type HttpRequest = Http.Request;
    public type HttpResponse = Http.Response;

    // public func http_request(request : HttpRequest) : async HttpResponse {

    // };
};