import Principal "mo:base/Principal";
import Time "mo:base/Time";
import Nat64 "mo:base/Nat64";
import Int "mo:base/Int";
import Map "mo:motoko-hash-map/Map";
import HashUtils "mo:motoko-hash-map/utils";
import Iter "mo:base/Iter";
import Buffer "mo:base/Buffer";
import Order "mo:base/Order";
import Option "mo:base/Option";
import Text "mo:base/Text";
import Debug "mo:base/Debug";

module Proposal {

  public type ProposalTupel = (uuid : Text, proposal : Proposal);
  public type Proposals = Map.Map<Text, Proposal>;
  let { thash } = Map;
  public let proposalMapType : Map.HashUtils<Text> = thash;

  public type ProposalStatus = {
    #isDraft;
    #isPublished;
    #votingHasFinsihed;
    #isArchived;
  };

  public type Proposal = {
    title : Text;
    description : Text;
    payload : Text;
    status : ProposalStatus;
    owner : Principal;
    created : Int;
    updated : Int;
  };

  public type PrincipalStatus = {
    #isNull;
    #isAnonymous;
    #isReal;
  };

  func evaluatePrincipalStatus(principal : ?Principal) : PrincipalStatus {
    switch (principal) {
      case (?principal) {
        if (Principal.isAnonymous(principal)) {
          return #isAnonymous;
        } else {
          return #isReal;
        };
      };
      case (null) {
        return #isNull;
      };
    };
  };

  func canAccessProposal(
    principalStatus : PrincipalStatus,
    propsoalStatus : ProposalStatus,
    owner : ?Principal,
    principal : ?Principal,
  ) : Bool {
    if (propsoalStatus == #isDraft and principalStatus == #isReal and Principal.equal(Option.unwrap(owner), Option.unwrap(principal))) {
      return true;
    };

    if (propsoalStatus != #isDraft) {
      return true;
    };

    false;
  };

  public func make(
    title : Text,
    description : Text,
    payload : Text,
    owner : Principal,
  ) : Proposal {
    let proposal : Proposal = {
      title = title;
      description = description;
      payload = payload;
      status = #isDraft;
      owner = owner;
      created = Int.abs(Time.now());
      updated = Int.abs(Time.now());
    };
    return proposal;
  };

  public func createOrUpdate(proposals : Map.Map<Text, Proposal>, uuid : Text, proposal : Proposal) : () {
    Map.set<Text, Proposal>(proposals, proposalMapType, uuid, proposal);
  };

  public func get(proposals : Map.Map<Text, Proposal>, uuid : Text, principal : ?Principal) : ?Proposal {
    let proposal = Map.get<Text, Proposal>(proposals, proposalMapType, uuid);
    switch (proposal) {
      case (?proposal) {
        if (canAccessProposal(evaluatePrincipalStatus(principal), proposal.status, ?proposal.owner, principal)) {
          ?proposal;
        } else {
          null;
        };
      };
      case (null) {
        return null;
      };
    };
  };

  public func all(proposals : Map.Map<Text, Proposal>, principal : ?Principal) : [ProposalTupel] {
    var proposalIter : Iter.Iter<ProposalTupel> = Map.entries<Text, Proposal>(proposals);
    switch (evaluatePrincipalStatus(principal)) {
      case (#isAnonymous or #isNull) {
        proposalIter := Iter.filter<ProposalTupel>(
          proposalIter,
          func(proposalTupel : ProposalTupel) : Bool {
            let (_, proposal : Proposal) = proposalTupel;
            proposal.status != #isDraft;
          },
        );
      };
      case (#isReal) {
        proposalIter := Iter.filter<ProposalTupel>(
          proposalIter,
          func(proposalTupel : ProposalTupel) : Bool {
            let (_, proposal : Proposal) = proposalTupel;
            proposal.status != #isDraft or ?proposal.owner == principal;
          },
        );
      };
    };
    let prosalsArray : [ProposalTupel] = Iter.toArray(proposalIter);
    prosalsArray;
  };

};
