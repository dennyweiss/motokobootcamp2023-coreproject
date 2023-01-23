import Webpage "canister:webpage";
import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";
import Int "mo:base/Int";
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
import Float "mo:base/Float";
import Iter "mo:base/Iter";
import VoteFinalizer "../modules/VoteFinalizer";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";

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
          votingResult = #pending;
          adoptValue = 0;
          rejectValue = 0;
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
          votingResult = #pending;
          adoptValue = 0;
          rejectValue = 0;
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
      #err("insufficient voting power for submitting a proposal");
    };
  };

  //////////////////////////////////////////////////////////////////////////////
  // Voting ////////////////////////////////////////////////////////////////////
  type Vote = Vote.Vote;

  stable var votes : Vote.Votes = Map.new<Text, Vote>();

  // 👇 implementation of `vote`
  public shared ({ caller }) func vote(proposalId : Text, voteValue : Vote.VoteValue) : async Result.Result<(), Text> {

    let account = { owner = caller; subaccount = null };
    let mbTokenBalance : Ledger.Tokens = await Ledger.createActor(environment).icrc1_balance_of(account);
    if (not VotingPower.hasMinimalVotingPowerFromTokens(mbTokenBalance)) {
      return #err("insufficient voting power for vote for a proposal");
    };

    let proposal = Proposal.get(proposals, proposalId, ?caller);

    switch (proposal) {
      case (?proposal) {
        if (proposal.status == #isDraft or proposal.status == #isArchived) {
          return #err("voting is only allowed for proposals with published state");
        };

        Debug.print(debug_show ({ id : Text = proposalId; proposal : Proposal.ProposalStatus = proposal.status }));

        if (Vote.hasVoted(votes, proposalId, caller)) {
          return #err("voting denied already voted");
        };

        let vote = Vote.castVote(
          votes,
          proposalId,
          await UUIDFactory.create(),
          caller,
          voteValue,
          VotingPower.normalizedFromTokens(mbTokenBalance),
        );

        let votingMetrics : Vote.VotingMetrics = Vote.resolveVotingResult(votes, proposalId);

        switch (votingMetrics.votingResult) {
          case (#adopted) {
            let updatedProposal = {
              title = proposal.title;
              description = proposal.description;
              payload = proposal.payload;
              status = #isArchived;
              owner = proposal.owner;
              created = proposal.created;
              updated = Int.abs(Time.now());
              votingResult = votingMetrics.votingResult;
              adoptValue = votingMetrics.adoptValue;
              rejectValue = votingMetrics.rejectValue;
            };
            Proposal.createOrUpdate(proposals, proposalId, updatedProposal);
            await Webpage.updateWebpageContent(proposal.payload);
            return #ok();
          };
          case (#pending) {
            let updatedProposal = {
              title = proposal.title;
              description = proposal.description;
              payload = proposal.payload;
              status = proposal.status;
              owner = proposal.owner;
              created = proposal.created;
              updated = Int.abs(Time.now());
              votingResult = votingMetrics.votingResult;
              adoptValue = votingMetrics.adoptValue;
              rejectValue = votingMetrics.rejectValue;
            };
            Proposal.createOrUpdate(proposals, proposalId, updatedProposal);
            return #ok();
          };
          case (#rejected) {
            let updatedProposal = {
              title = proposal.title;
              description = proposal.description;
              payload = proposal.payload;
              status = #isArchived;
              owner = proposal.owner;
              created = proposal.created;
              updated = Int.abs(Time.now());
              votingResult = votingMetrics.votingResult;
              adoptValue = votingMetrics.adoptValue;
              rejectValue = votingMetrics.rejectValue;
            };
            Proposal.createOrUpdate(proposals, proposalId, updatedProposal);
            return #ok();
          };
        };

      };
      case (null) {
        return #err("proposal not found");
      };
    };
  };

  public shared ({ caller }) func allVotes() : async [Vote.VotesTupel] {
    var votesIter : Iter.Iter<Vote.VotesTupel> = Map.entries<Text, Vote>(votes);

    // all votes by proposalId
    let proposapId : Text = "0dc8c77e-544c-4a3f-b9f5-5b6cdba1b136";
    votesIter := Iter.filter<Vote.VotesTupel>(
      votesIter,
      func(item : Vote.VotesTupel) : Bool {
        let (_, vote : Vote) = item;
        vote.proposalId == proposapId;
      },
    );

    let votessArray : [Vote.VotesTupel] = Iter.toArray(votesIter);
    votessArray;
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
