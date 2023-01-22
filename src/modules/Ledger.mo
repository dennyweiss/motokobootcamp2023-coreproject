import Environment "Environment";
import CanisterResolver "CanisterResolver";

module Ledger {
  public type Tokens = Nat;
  public type Subaccount = Blob;
  type Account = { owner : Principal; subaccount : ?Subaccount };
  type Ledger = actor { icrc1_balance_of : (Account) -> async Tokens };
  public let minimalTokenBalance : Nat = 100_000_000;

  public func createActor(environment : Environment.EnvironmentType) : Ledger {
    var ledgerCanisterId : Text = CanisterResolver.resolve(environment, #ledger);
    actor (ledgerCanisterId);
  };
};
