import Principal "mo:base/Principal";
import Bool "mo:base/Bool";
import Int "mo:base/Int";
import Time "mo:base/Time";
import Proposal "Proposal";

module Vote {

  public type Vote = {
    proposalId : Int;
    yesOrNo : ?Bool;
    principal : Principal;
    tokenCount : ?Int;
    created : Int;
  };

  public func create(
    proposalId : Int,
    principal : Principal,
  ) : Vote {
    return {
      proposalId = proposalId;
      yesOrNo = null;
      principal = principal;
      tokenCount = null;
      created = Int.abs(Time.now());
    };
  };

  public func castVote(proposal : Vote, yesOrNo : ?Bool, tokenCount: ?Int) : Vote {
    return {
      proposalId = proposal.proposalId;
      yesOrNo = yesOrNo;
      principal = proposal.principal;
      tokenCount = tokenCount;
      created = Int.abs(Time.now());
    };
  }

};
