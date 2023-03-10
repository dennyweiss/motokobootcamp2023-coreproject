import Float "mo:base/Float";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Int64 "mo:base/Int64";
import Result "mo:base/Result";
import Nat64 "mo:base/Nat64";

module VotingPower {
  public type VotingPower = Float;
  public let normalizedMinimalVotingPower : VotingPower = 1.0;
  public let decimals : Nat = 8;
  public let base : Nat = 10;
  public func toFloat(number : Nat) : Float {
    Float.fromInt64(Int64.fromInt(number));
  };

  public func toNat(value : VotingPower) : Nat {
    let powerFloat : Float = toFloat(decimals);
    let baseFloat : Float = toFloat(base);
    let decimalsFactorFloat : Float = baseFloat ** powerFloat;
    let result = value * decimalsFactorFloat;
    let resultNat : Nat = Nat64.toNat(Int64.toNat64(Float.toInt64(result)));
  };

  public func normalizedFromTokens(tokens : Nat) : VotingPower {
    let powerFloat : Float = toFloat(decimals);
    let baseFloat : Float = toFloat(base);
    let decimalsFactorFloat : Float = baseFloat ** powerFloat;
    return toFloat(tokens) / decimalsFactorFloat;
  };

  public func hasMinimalVotingPowerFromTokens(tokens : Nat) : Bool {
    hasMinimalVotingPower(normalizedFromTokens(tokens));
  };

  public func hasMinimalVotingPower(votingPower : VotingPower) : Bool {
    Float.greaterOrEqual(votingPower, normalizedMinimalVotingPower);
  };

};
