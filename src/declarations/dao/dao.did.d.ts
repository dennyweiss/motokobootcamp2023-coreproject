import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export type EnvironmentType = { 'ic' : null } |
  { 'local' : null };
export interface Proposal {
  'status' : ProposalStatus,
  'title' : string,
  'created' : bigint,
  'owner' : Principal,
  'description' : string,
  'votingResult' : VotingResult,
  'rejectValue' : VotingPower,
  'adoptValue' : VotingPower,
  'updated' : bigint,
  'payload' : string,
}
export type ProposalStatus = { 'isPublished' : null } |
  { 'isArchived' : null } |
  { 'isDraft' : null };
export type ProposalTupel = [string, Proposal];
export interface Proposal__1 {
  'status' : ProposalStatus,
  'title' : string,
  'created' : bigint,
  'owner' : Principal,
  'description' : string,
  'votingResult' : VotingResult,
  'rejectValue' : VotingPower,
  'adoptValue' : VotingPower,
  'updated' : bigint,
  'payload' : string,
}
export type Result = { 'ok' : null } |
  { 'err' : string };
export type Tokens = bigint;
export interface Vote {
  'voteValue' : VoteValue,
  'votingPower' : VotingPower,
  'voter' : Principal,
  'createdAt' : bigint,
  'proposalId' : string,
}
export type VoteValue = { 'reject' : null } |
  { 'adopt' : null };
export type VotesTupel = [string, Vote];
export type VotingPower = number;
export type VotingResult = { 'pending' : null } |
  { 'rejected' : null } |
  { 'adopted' : null };
export interface _SERVICE {
  'allVotes' : ActorMethod<[], Array<VotesTupel>>,
  'changeState' : ActorMethod<[string, ProposalStatus], Result>,
  'getBalance' : ActorMethod<[], Tokens>,
  'getProposal' : ActorMethod<[string], [] | [Proposal__1]>,
  'getProposals' : ActorMethod<[], Array<ProposalTupel>>,
  'setEnvironment' : ActorMethod<[EnvironmentType], EnvironmentType>,
  'submitProposal' : ActorMethod<[string, string, string], Result>,
  'updateContent' : ActorMethod<[string, string, string, string], Result>,
  'updateWebpageContent' : ActorMethod<[string], undefined>,
  'vote' : ActorMethod<[string, VoteValue], Result>,
}
