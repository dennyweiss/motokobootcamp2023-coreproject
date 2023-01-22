import Principal "mo:base/Principal";
import Time "mo:base/Time";
import Nat64 "mo:base/Nat64";
import Int "mo:base/Int";

module Proposal {

  public type ProposalStatus = {
    #isDraft;
    #isPublished;
    #votingHasFinsihed;
    #isArchived;
  };

 public type Proposal = {
    title : Text;
    description : Text;
    payload: Text;
    status : ProposalStatus;
    owner : Principal;
    created : Int;
    updated : Int;
  };

  public func create( 
    title : Text, 
    description : Text, 
    payload : Text ,
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

  public func makeDraft(proposal : Proposal) : Proposal {
    return {
      title = proposal.title;
      description = proposal.description;
      payload = proposal.payload;
      status = #isDraft;
      owner = proposal.owner;
      created = proposal.created;
      updated = Int.abs(Time.now());
    };

  };

  public func publish(proposal : Proposal) : Proposal {
    return {
      title = proposal.title;
      description = proposal.description;
      payload = proposal.payload;
      status = #isPublished;
      owner = proposal.owner;
      created = proposal.created;
      updated = Int.abs(Time.now());
    };
  };

  public func finalize(proposal : Proposal ) : Proposal {
    return {
      title = proposal.title;
      description = proposal.description;
      payload = proposal.payload;
      status = #votingHasFinsihed;
      owner = proposal.owner;
      created = proposal.created;
      updated = Int.abs(Time.now());
    };
  };

  public func archive(proposal : Proposal) : Proposal {
    return {
      title = proposal.title;
      description = proposal.description;
      payload = proposal.payload;
      status = #isArchived;
      owner = proposal.owner;
      votingFinished = false;
      created = proposal.created;
      updated = Int.abs(Time.now());
    };
  };

  public func update(proposal : Proposal) : Proposal {
    return {
      title = proposal.title;
      description = proposal.description;
      payload = proposal.payload;
      status = proposal.status;
      owner = proposal.owner;
      created = proposal.created;
      updated = Int.abs(Time.now());
    };
  };

};
