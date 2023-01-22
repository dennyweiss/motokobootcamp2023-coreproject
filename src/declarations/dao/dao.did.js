export const idlFactory = ({ IDL }) => {
  const Proposal = IDL.Record({
    'status' : IDL.Text,
    'title' : IDL.Text,
    'created' : IDL.Int,
    'owner' : IDL.Principal,
    'description' : IDL.Text,
    'votingFinished' : IDL.Bool,
    'updated' : IDL.Int,
  });
  return IDL.Service({
    'getAllProposals' : IDL.Func(
        [],
        [IDL.Vec(IDL.Tuple(IDL.Int, Proposal))],
        ['query'],
      ),
    'getContent' : IDL.Func([], [IDL.Text], []),
    'getEnvironment' : IDL.Func([], [IDL.Text], []),
    'getProposal' : IDL.Func([IDL.Int], [IDL.Opt(Proposal)], ['query']),
    'setEnvironment' : IDL.Func([IDL.Text], [], []),
    'submitProposal' : IDL.Func([IDL.Text, IDL.Text], [], []),
    'updateWebpageContent' : IDL.Func([IDL.Text], [], []),
    'vote' : IDL.Func([IDL.Int, IDL.Bool], [], []),
  });
};
export const init = ({ IDL }) => { return []; };
