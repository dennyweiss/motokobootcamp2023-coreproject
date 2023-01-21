import Webpage "canister:webpage";
import Environment "../support/Environment";
import Principal "mo:base/Principal";
import Admin "../support/Admin";

actor Dao {
  //////////////////////////////////////////////////////////////////////////////
  // Environment Guards ////////////////////////////////////////////////////////
  stable var environment : Text = "local";
  let environments : [Environment.Environment] = [
    {
      name = "local";
      principals = [
        "rrkah-fqaaa-aaaaa-aaaaq-cai",
      ];
    },
    { name = "ic"; principals = [] },
  ];
  let guard = Environment.PrincipalGuard(environments);

  public shared ({ caller }) func setEnvironment(environmentName : Text) : async () {
    assert (Admin.isAdmin(caller));
    environment := environmentName;
    ();
  };

  public func getEnvironment() : async Text {
    return environment;
  };

  //////////////////////////////////////////////////////////////////////////////
  // Proposal //////////////////////////////////////////////////////////////////
  type Proposal = {}; // TO DEFINE;

  public query func get_proposal(id : Int) : async ?Proposal {
    return null;
  };

  public query func get_all_proposals() : async [(Int, Proposal)] {
    return [];
  };
  
  public shared ({ caller }) func submit_proposal(this_payload : Text) : async {
    #Ok : Proposal;
    #Err : Text;
  } {
    return #Err("Not implemented yet");
  };

  //////////////////////////////////////////////////////////////////////////////
  // Voting ////////////////////////////////////////////////////////////////////
  public shared ({ caller }) func vote(proposal_id : Int, yes_or_no : Bool) : async {
    #Ok : (Nat, Nat);
    #Err : Text;
  } {
    return #Err("Not implemented yet");
  };

  //////////////////////////////////////////////////////////////////////////////
  // Utility ///////////////////////////////////////////////////////////////////
  public shared ({ caller }) func updateWebpageContent(content : Text) : async () {
    assert( environment == "local" );
    await Webpage.updateWebpageContent(content);
  };
};
