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
import VotingPower "../modules/VotingPower";
import Map "mo:motoko-hash-map/Map";
import Option "mo:base/Option";
import Time "mo:base/Time";

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
  stable var proposals : Proposal.Proposals = Map.new<Text, Proposal>();

  // 👇 implementation of `get_proposal`
  public shared ({ caller }) func getProposal(uuid : Text) : async ?Proposal {
    Proposal.get(proposals, uuid, ?caller);
  };

  // 👇 implementation of `get_all_proposals`
  public shared ({ caller }) func getProposals() : async [Proposal.ProposalTupel] {
    Proposal.all(proposals, ?caller);
  };

  public shared ({ caller }) func updateContent(
    uuid : Text,
    title : Text,
    description : Text,
    payload : Text,
  ) : async Result.Result<(), Text> {

    let proposal = Proposal.get(proposals, uuid, ?caller);

    switch (proposal) {
      case (?proposal) {
        if (not Principal.equal(proposal.owner, caller)) {
          return #err("only proposal owner are allowed to change proposals");
        };
        if (proposal.status != #isDraft) {
          return #err("only proposals with draft status can be updated");
        };
        let newProposal : Proposal = {
          title = title;
          description = description;
          payload = payload;
          status = proposal.status;
          owner = proposal.owner;
          created = proposal.created;
          updated = Int.abs(Time.now());
        };
        Proposal.createOrUpdate(proposals, uuid, newProposal);
        return #ok();
      };
      case (null) {
        return #err("proposal not found");
      };
    };
  };

  public shared ({ caller }) func changeState(uuid : Text, status : Proposal.ProposalStatus) : async Result.Result<(), Text> {
    if (status != #isPublished and status != #isArchived) {
      return #err("state change not allowed");
    };

    let proposal = Proposal.get(proposals, uuid, ?caller);

    switch (proposal) {
      case (?proposal) {
        if (proposal.status == #isArchived) {
          return #err("archived proposals can't be unarchived");
        };
        let newProposal : Proposal = {
          title = proposal.title;
          description = proposal.description;
          payload = proposal.payload;
          status = status;
          owner = proposal.owner;
          created = proposal.created;
          updated = Int.abs(Time.now());
        };
        Proposal.createOrUpdate(proposals, uuid, newProposal);
        return #ok();
      };
      case (null) {
        return #err("proposal not found");
      };
    };
  };

  // 👇 implementation of `submit_proposal`
  public shared ({ caller }) func submitProposal(
    title : Text,
    description : Text,
    payload : Text,
  ) : async Result.Result<(), Text> {
    let account = { owner = caller; subaccount = null };
    let mbTokenBalance : Ledger.Tokens = await Ledger.createActor(environment).icrc1_balance_of(account);
    if (VotingPower.hasMinimalVotingPowerFromTokens(mbTokenBalance)) {
      let proposal = Proposal.make(
        title,
        description,
        payload,
        caller,
      );
      let uuid : Text = await UUIDFactory.create();
      Proposal.createOrUpdate(proposals, uuid, proposal);
      Debug.print(debug_show (VotingPower.normalizedFromTokens(mbTokenBalance)));
      Debug.print(debug_show ({ uuid : Text = uuid; proposal : Proposal = proposal }));
      #ok();
    } else {
      #err("insufficient voting power for submitting a proposal" # Nat.toText(mbTokenBalance));
    };
  };

  //////////////////////////////////////////////////////////////////////////////
  // Voting ////////////////////////////////////////////////////////////////////
  type Vote = Vote.Vote;
  stable var votesIdCount : Nat = 0;
  var votes = HashMap.HashMap<Int, Vote>(1, Int.equal, Int.hash);

  // 👇 implementation of `vote`
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
