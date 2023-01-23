export const idlFactory = ({ IDL }) => {
  const VoteValue = IDL.Variant({ 'reject' : IDL.Null, 'adopt' : IDL.Null });
  const VotingPower = IDL.Float64;
  const Vote = IDL.Record({
    'voteValue' : VoteValue,
    'votingPower' : VotingPower,
    'voter' : IDL.Principal,
    'createdAt' : IDL.Int,
    'proposalId' : IDL.Text,
  });
  const VotesTupel = IDL.Tuple(IDL.Text, Vote);
  const ProposalStatus = IDL.Variant({
    'isPublished' : IDL.Null,
    'isArchived' : IDL.Null,
    'isDraft' : IDL.Null,
  });
  const Result = IDL.Variant({ 'ok' : IDL.Null, 'err' : IDL.Text });
  const Tokens = IDL.Nat;
  const VotingResult = IDL.Variant({
    'pending' : IDL.Null,
    'rejected' : IDL.Null,
    'adopted' : IDL.Null,
  });
  const Proposal__1 = IDL.Record({
    'status' : ProposalStatus,
    'title' : IDL.Text,
    'created' : IDL.Int,
    'owner' : IDL.Principal,
    'description' : IDL.Text,
    'votingResult' : VotingResult,
    'rejectValue' : VotingPower,
    'adoptValue' : VotingPower,
    'updated' : IDL.Int,
    'payload' : IDL.Text,
  });
  const Proposal = IDL.Record({
    'status' : ProposalStatus,
    'title' : IDL.Text,
    'created' : IDL.Int,
    'owner' : IDL.Principal,
    'description' : IDL.Text,
    'votingResult' : VotingResult,
    'rejectValue' : VotingPower,
    'adoptValue' : VotingPower,
    'updated' : IDL.Int,
    'payload' : IDL.Text,
  });
  const ProposalTupel = IDL.Tuple(IDL.Text, Proposal);
  const EnvironmentType = IDL.Variant({ 'ic' : IDL.Null, 'local' : IDL.Null });
  return IDL.Service({
    'allVotes' : IDL.Func([], [IDL.Vec(VotesTupel)], []),
    'changeState' : IDL.Func([IDL.Text, ProposalStatus], [Result], []),
    'getBalance' : IDL.Func([], [Tokens], []),
    'getProposal' : IDL.Func([IDL.Text], [IDL.Opt(Proposal__1)], []),
    'getProposals' : IDL.Func([], [IDL.Vec(ProposalTupel)], []),
    'setEnvironment' : IDL.Func([EnvironmentType], [EnvironmentType], []),
    'submitProposal' : IDL.Func([IDL.Text, IDL.Text, IDL.Text], [Result], []),
    'updateContent' : IDL.Func(
        [IDL.Text, IDL.Text, IDL.Text, IDL.Text],
        [Result],
        [],
      ),
    'updateWebpageContent' : IDL.Func([IDL.Text], [], []),
    'vote' : IDL.Func([IDL.Text, VoteValue], [Result], []),
  });
};
export const init = ({ IDL }) => { return []; };
