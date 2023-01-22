import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export interface Proposal {
  'status' : string,
  'title' : string,
  'created' : bigint,
  'owner' : Principal,
  'description' : string,
  'votingFinished' : boolean,
  'updated' : bigint,
}
export interface _SERVICE {
  'getAllProposals' : ActorMethod<[], Array<[bigint, Proposal]>>,
  'getContent' : ActorMethod<[], string>,
  'getEnvironment' : ActorMethod<[], string>,
  'getProposal' : ActorMethod<[bigint], [] | [Proposal]>,
  'setEnvironment' : ActorMethod<[string], undefined>,
  'submitProposal' : ActorMethod<[string, string], undefined>,
  'updateWebpageContent' : ActorMethod<[string], undefined>,
  'vote' : ActorMethod<[bigint, boolean], undefined>,
}
