import Principal "mo:base/Principal";
import Bool "mo:base/Bool";
import Int "mo:base/Int";
import Time "mo:base/Time";
import VotingPower "../VotingPower";
import Map "mo:motoko-hash-map/Map";
import Iter "mo:base/Iter";
import Float "mo:base/Float";

module Vote {

  public type Votes = Map.Map<Text, Vote>;
  let { thash } = Map;
  public let voteMapType : Map.HashUtils<Text> = thash;
  public let finalizingVotingPower : Float = 100.0;

  public type VotesTupel = (uuid : Text, vote : Vote);

  public type VotingResult = {
    #pending;
    #adopted;
    #rejected;
  };

  public type VotingMetrics = {
    votingResult : VotingResult;
    adoptValue : Float;
    rejectValue : Float;
  };

  public type VoteValue = {
    #adopt;
    #reject;
  };

  public type Vote = {
    proposalId : Text;
    voter : Principal;
    voteValue : VoteValue;
    votingPower : VotingPower.VotingPower;
    createdAt : Int;
  };

  public func resolveVotingResult(
    votes : Map.Map<Text, Vote>,
    proposalId : Text,
  ) : VotingMetrics {
    var votesIter : Iter.Iter<VotesTupel> = Map.entries<Text, Vote>(votes);
    votesIter := Iter.filter<VotesTupel>(
      votesIter,
      func(item : VotesTupel) : Bool {
        let (_, vote : Vote) = item;
        vote.proposalId == proposalId;
      },
    );

    var votingResult : VotingResult = #pending;
    var adoptValue : Float = 0;
    var rejectValue : Float = 0;
    Iter.iterate<VotesTupel>(
      votesIter,
      func(item : VotesTupel, number) : () {
        let (_, vote : Vote) = item;
        if (vote.voteValue == #adopt) {
          adoptValue := Float.add(adoptValue, vote.votingPower);
        };

        if (vote.voteValue == #reject) {
          rejectValue := Float.add(rejectValue, vote.votingPower);
        };
      },
    );

    if ((adoptValue + rejectValue) >= finalizingVotingPower) {
      if (adoptValue > rejectValue) {
        votingResult := #adopted;
      } else {
        votingResult := #adopted;
      };
    };

    {
      votingResult : VotingResult = votingResult;
      adoptValue : Float = adoptValue;
      rejectValue : Float = rejectValue;
    };
  };

  public func hasVoted(
    votes : Map.Map<Text, Vote>,
    proposalId : Text,
    principal : Principal,
  ) : Bool {
    var votesIter : Iter.Iter<VotesTupel> = Map.entries<Text, Vote>(votes);
    votesIter := Iter.filter<VotesTupel>(
      votesIter,
      func(item : VotesTupel) : Bool {
        let (_, vote : Vote) = item;
        vote.proposalId == proposalId and Principal.equal(vote.voter, principal);
      },
    );

    Iter.size(votesIter) > 0;
  };

  public func castVote(
    votes : Map.Map<Text, Vote>,
    proposalId : Text,
    voteId : Text,
    voter : Principal,
    voteValue : VoteValue,
    votingPower : VotingPower.VotingPower,
  ) : () {

    let vote : Vote = {
      proposalId = proposalId;
      voter = voter;
      voteValue = voteValue;
      votingPower = votingPower;
      createdAt = Int.abs(Time.now());
    };

    Map.set<Text, Vote>(votes, voteMapType, voteId, vote);
  };

};
