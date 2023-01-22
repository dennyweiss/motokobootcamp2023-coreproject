import Webpage "canister:webpage";
import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import EnvironmentGuards "../modules/guards/EnvironmentGuards";
import PrincipleTypeGuard "../modules/guards/PrincipleTypeGuard";
import Environment "../modules/Environment";
import Proposal "../modules/models/Proposal";
import Vote "../modules/models/Vote";
import Debug "mo:base/Debug";
import Result "mo:base/Result";
import AccountIdentifier "mo:principal/AccountIdentifier";
import Text "mo:base/Text";
import CanisterResolver "../modules/CanisterResolver";
import AccountHelper "../modules/AccountHelper";
import UUIDFactory "../modules/UUIDFactory";

actor Dao {
  //////////////////////////////////////////////////////////////////////////////
  // Environment Guards ////////////////////////////////////////////////////////
  stable var environment : Environment.EnvironmentType = #local;
  let environmentPrincipalGard = EnvironmentGuards.EnvironmentPrincipalGard();
  environmentPrincipalGard.registerEnvironment({
    environmentType = #local;
    principals = ["4wtdz-zhyfn-46p4d-apw5i-weord-ktvsf-n4jge-qqsf6-ftski-i7fr3-pqe"];
  });
  environmentPrincipalGard.registerEnvironment({
    environmentType = #ic;
    principals = ["4wtdz-zhyfn-46p4d-apw5i-weord-ktvsf-n4jge-qqsf6-ftski-i7fr3-pqe"];
  });

  public shared ({ caller }) func setEnvironment(environmentName : Environment.EnvironmentType) : async Environment.EnvironmentType {
    assert (PrincipleTypeGuard.is(caller, #admin));
    environment := environmentName;
    environment;
  };

  //////////////////////////////////////////////////////////////////////////////
  // Proposal //////////////////////////////////////////////////////////////////
  type Proposal = Proposal.Proposal;
  var proposals = HashMap.HashMap<Text, Proposal>(1, Text.equal, Text.hash);

  public query func getProposal(uuid : Text) : async ?Proposal {
    // 1. Auth

    //2. Query data.
    let proposal : ?Proposal = proposals.get(uuid);

    //3. Return requested Post or null.
    proposal;
  };

  public query func getAllProposals() : async [(Text, Proposal)] {
    //1. authenticate

    //2. Hashmap to Iter.
    let proposalIter : Iter.Iter<(Text, Proposal)> = proposals.entries();

    //3. Iter to Array.
    let proposalArray : [(Text, Proposal)] = Iter.toArray(proposalIter);

    //4. Iter to Array.
    proposalArray;
  };

  public shared ({ caller }) func submitProposal(title : Text, description : Text) : async () {
    //1. auth
    let proposal = Proposal.create(title, description, caller);
    proposals.put(await UUIDFactory.create(), proposal);

    //4. return confirmation.
    (); // @todo make use of meaningful Result
  };

  //////////////////////////////////////////////////////////////////////////////
  // Voting ////////////////////////////////////////////////////////////////////
  type Vote = Vote.Vote;
  stable var votesIdCount : Nat = 0;
  var votes = HashMap.HashMap<Int, Vote>(1, Int.equal, Int.hash);

  public shared ({ caller }) func vote(proposalId : Int, yesOrNo : Bool) : async () {
    //1. auth

    //2. Prepare data.
    let id : Nat = votesIdCount;
    votesIdCount += 1;
    let vote = Vote.create(id, caller);

    //3. Create vote.
    votes.put(id, vote);

    //4. return confirmation.
    ();
  };

  //////////////////////////////////////////////////////////////////////////////
  // Utility ///////////////////////////////////////////////////////////////////
  public shared ({ caller }) func updateWebpageContent(content : Text) : async () {
    assert (PrincipleTypeGuard.is(caller, #admin));
    await Webpage.updateWebpageContent(content);
  };

  public shared ({ caller }) func accountId() : async {
    principle : {
      id : Text;
      account : Text;
    };
    canister : {
      id : Text;
      account : Text;
    };
  } {
    assert (PrincipleTypeGuard.is(caller, #admin));
    {
      principle = {
        id = Principal.toText(caller);
        account = AccountHelper.inspectAccount(caller);
      };
      canister = {
        id = CanisterResolver.resolve(environment, #dao);
        account = AccountHelper.inspectAccount(Principal.fromText(CanisterResolver.resolve(environment, #dao)));
      };
    };
  };

  //////////////////////////////////////////////////////////////////////////////
  // inter canister communication with ledger //////////////////////////////////
  public type Tokens = Nat;
  type Account = { owner : Principal; subaccount : ?Subaccount };
  public type Subaccount = Blob;
  var ledgerCanisterId : Text = CanisterResolver.resolve(environment, #ledger);

  let ledger : actor { icrc1_balance_of : (Account) -> async Tokens } = actor (ledgerCanisterId);

  public shared ({ caller }) func getBalance() : async Nat {
    let account = { owner = caller; subaccount = null };
    let amount = await ledger.icrc1_balance_of(account);
    return amount;
  };

  public shared ({ caller }) func getPrincipal() : async Principal {
    caller;
  };

  // (record (principal "4wtdz-zhyfn-46p4d-apw5i-weord-ktvsf-n4jge-qqsf6-ftski-i7fr3-pqe")
};
