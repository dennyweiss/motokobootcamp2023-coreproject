import Webpage "canister:webpage";
import Environment "../support/Environment";
import Principal "mo:base/Principal";
import Admin "../support/Admin";
import Proposal "../support/Proposal";
import HashMap "mo:base/HashMap";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Vote "../support/Vote";

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
  type Proposal = Proposal.Proposal;

  stable var proposalIdCount : Nat = 0;
  var proposals = HashMap.HashMap<Int, Proposal>(1, Int.equal, Int.hash);

  public query func getProposal(id : Int) : async ?Proposal {
    // 1. Auth

    //2. Query data.
    let proposal : ?Proposal = proposals.get(id);

    //3. Return requested Post or null.
    proposal;
  };

  public query func getAllProposals() : async [(Int, Proposal)] {
    //1. authenticate

    //2. Hashmap to Iter.
    let proposalIter : Iter.Iter<(Int, Proposal)> = proposals.entries();

    //3. Iter to Array.
    let proposalArray : [(Int, Proposal)] = Iter.toArray(proposalIter);

    //4. Iter to Array.
    proposalArray;
  };

  public shared ({ caller }) func submitProposal(title : Text, description : Text) : async () {
    //1. auth

    //2. Prepare data.
    let id : Nat = proposalIdCount;
    proposalIdCount += 1;
    let proposal = Proposal.create(title, description, caller);

    //3. Create Proposal.
    proposals.put(id, proposal);

    //4. return confirmation.
    ();

  };

  //////////////////////////////////////////////////////////////////////////////
  // Voting ////////////////////////////////////////////////////////////////////
  type Vote = Vote.Vote;
  stable var votesIdCount : Nat = 0;
  var votes = HashMap.HashMap<Int, Vote>(1, Int.equal, Int.hash);

  public shared ({ caller }) func vote(proposalId : Int, yesOrNo : Bool) : async () {
    //1. auth

    //2. Prepare data.
    let id : Nat = votesIdCount;
    votesIdCount += 1;
    let vote = Vote.create(id, caller);

    //3. Create vote.
    votes.put(id, vote);

    //4. return confirmation.
    ();
  };

  //////////////////////////////////////////////////////////////////////////////
  // Utility ///////////////////////////////////////////////////////////////////
  public shared ({ caller }) func updateWebpageContent(content : Text) : async () {
    assert (environment == "local");
    await Webpage.updateWebpageContent(content);
  };

  public func getContent() : async Text {
    return await Webpage.getContent();
  };

};
