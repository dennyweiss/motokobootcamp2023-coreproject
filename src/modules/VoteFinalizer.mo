import Result "mo:base/Result";
import Vote "models/Vote";

module VoteFinalizer {

  public func finalizeVote(proposalId : Text) : Vote.VotingResult {

    // 1.   filter votes by proposalId
    // 2.   reduce votes votes for #adopted
    // 3.   reduce votes votes for #rejected
    // 4.   finalize when #adopted + #rejected >= 100
    // 4.1. add voting result to proposal 
    // 4.2. add voting result to proposal 

    return #adopted;
  }


}