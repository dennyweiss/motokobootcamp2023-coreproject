import Principal "mo:base/Principal";
import Time "mo:base/Time";
import Nat64 "mo:base/Nat64";
import Int "mo:base/Int";

module Proposal {

  let statusDraft = "isDraft";
  let statusPublished = "isPublished";
  let statusArchived = "isArchived";

 public type Proposal = {
    title : Text;
    description : Text;
    status : Text;
    owner : Principal;
    votingFinished: Bool;
    created : Int;
    updated : Int;
  };

  public func create( title : Text, description : Text, owner : Principal ) : Proposal {
    let proposal : Proposal = {
      title = title;
      description = description;
      status = statusDraft;
      owner = owner;
      votingFinished = false;
      created = Int.abs(Time.now());
      updated = Int.abs(Time.now());
    };
    return proposal;
  };


  public func makeDraft(proposal : Proposal, owner : Principal ) : Proposal {
    return {
      title = proposal.title;
      description = proposal.description;
      status = statusDraft;
      owner = proposal.owner;
      votingFinished = false;
      created = proposal.created;
      updated = Int.abs(Time.now());
    };

  };

  public func publish(proposal : Proposal, owner : Principal ) : Proposal {
    return {
      title = proposal.title;
      description = proposal.description;
      status = statusPublished;
      owner = proposal.owner;
      votingFinished = false;
      created = proposal.created;
      updated = Int.abs(Time.now());
    };
  };

  public func archive(proposal : Proposal, owner : Principal ) : Proposal {
    return {
      title = proposal.title;
      description = proposal.description;
      status = statusArchived;
      owner = proposal.owner;
      votingFinished = false;
      created = proposal.created;
      updated = Int.abs(Time.now());
    };
  };

  public func update(proposal : Proposal, owner : Principal ) : Proposal {
    return {
      title = proposal.title;
      description = proposal.description;
      status = proposal.status;
      owner = proposal.owner;
      votingFinished = false;
      created = proposal.created;
      updated = Int.abs(Time.now());
    };
  };

};
