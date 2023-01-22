import Webpage "canister:webpage";
import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import EnvironmentGuards "../modules/guards/EnvironmentGuards";
import PrincipleTypeGuard "../modules/guards/PrincipleTypeGuard";
import Environment "../modules/Environment";
import Proposal "../modules/models/Proposal";
import Vote "../modules/models/Vote";
import Debug "mo:base/Debug";
import Result "mo:base/Result";
import AccountIdentifier "mo:principal/AccountIdentifier";
import Text "mo:base/Text";
import CanisterResolver "../modules/CanisterResolver";
import AccountHelper "../modules/AccountHelper";
import UUIDFactory "../modules/UUIDFactory";
import Ledger "../modules/Ledger";

actor Dao {
  //////////////////////////////////////////////////////////////////////////////
  // Environment Guards ////////////////////////////////////////////////////////
  stable var environment : Environment.EnvironmentType = #local;
  let environmentPrincipalGard = EnvironmentGuards.EnvironmentPrincipalGard();
  environmentPrincipalGard.registerEnvironment({
    environmentType = #local;
    principals = ["4wtdz-zhyfn-46p4d-apw5i-weord-ktvsf-n4jge-qqsf6-ftski-i7fr3-pqe"];
  });
  environmentPrincipalGard.registerEnvironment({
    environmentType = #ic;
    principals = ["4wtdz-zhyfn-46p4d-apw5i-weord-ktvsf-n4jge-qqsf6-ftski-i7fr3-pqe"];
  });

  public shared ({ caller }) func setEnvironment(environmentName : Environment.EnvironmentType) : async Environment.EnvironmentType {
    assert (PrincipleTypeGuard.is(caller, #admin));
    environment := environmentName;
    environment;
  };

  //////////////////////////////////////////////////////////////////////////////
  // Proposal //////////////////////////////////////////////////////////////////
  type Proposal = Proposal.Proposal;
  var proposals = HashMap.HashMap<Text, Proposal>(1, Text.equal, Text.hash);

  public query func getProposal(uuid : Text) : async ?Proposal {
    // 1. Auth
    //2. Query data.
    let proposal : ?Proposal = proposals.get(uuid);
    proposal;
  };

  public query func getAllProposals() : async [(Text, Proposal)] {
    //1. authenticate
    //2. Hashmap to Iter.
    let proposalIter : Iter.Iter<(Text, Proposal)> = proposals.entries();
    //3. Iter to Array.
    let proposalArray : [(Text, Proposal)] = Iter.toArray(proposalIter);
    //4. Iter to Array.
    proposalArray;
  };

  public shared ({ caller }) func submitProposal(
    title : Text,
    description : Text,
    payload : Text,
  ) : async Result.Result<(), Text> {
    let account = { owner = caller; subaccount = null };
    let mbTokenBalance : Ledger.Tokens = await Ledger.createActor(environment).icrc1_balance_of(account);
    Debug.print(debug_show({ current : Nat = mbTokenBalance; minimal : Nat = Ledger.minimalTokenBalance }));
    if (mbTokenBalance > Ledger.minimalTokenBalance) {
      let proposal = Proposal.create(
        title,
        description,
        payload,
        caller,
      );
      proposals.put(await UUIDFactory.create(), proposal);
      Debug.print(debug_show(proposal));
      #ok();
    } else {
      #err("Proposal account has insufficient funds to transfer " # Nat.toText(mbTokenBalance) );
    };
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
    assert (PrincipleTypeGuard.is(caller, #admin));
    await Webpage.updateWebpageContent(content);
  };

  //////////////////////////////////////////////////////////////////////////////
  // inter canister communication with ledger //////////////////////////////////
  public shared ({ caller }) func getBalance() : async Ledger.Tokens {
    let account = { owner = caller; subaccount = null };
    return await Ledger.createActor(environment).icrc1_balance_of(account);
  };

};
