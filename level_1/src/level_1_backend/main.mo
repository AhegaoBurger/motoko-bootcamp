import Buffer "mo:base/Buffer";
// import Iter "mo:base/Iter";

actor {
    let name: Text = "WiseTech";

    var manifesto: Text = "Harnessing Collective Wisdom for Technological Empowerment.";
    
    public query func getName() : async Text {
      return name;
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

   
}