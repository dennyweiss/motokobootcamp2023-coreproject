import Environment "Environment";

module Ledger {
  public func ledgerCanisterResolver(environmentType : Environment.EnvironmentType) : Text {
    switch (environmentType) {
      case (#local) "ryjl3-tyaaa-aaaaa-aaaba-cai";
      case (#staging) "";
      case (#ic) "db3eq-6iaaa-aaaah-abz6a-cai";
    };
  };
};
