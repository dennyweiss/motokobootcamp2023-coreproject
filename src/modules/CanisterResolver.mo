import Environment "Environment";

module CanisterResolver {
  public type CanisterType = {
    #dao;
    #ledger;
  };
  public func resolve(
    environmentType : Environment.EnvironmentType,
    canisterType : CanisterType,
  ) : Text {
    switch (canisterType) {
      case (#dao) {
        switch (environmentType) {
          case (#local) "r7inp-6aaaa-aaaaa-aaabq-cai";
          case (#ic) "usg2o-yyaaa-aaaak-qbu5q-cai";
        };
      };
      case (#ledger) {
        switch (environmentType) {
          case (#local) "rkp4c-7iaaa-aaaaa-aaaca-cai";
          case (#ic) "db3eq-6iaaa-aaaah-abz6a-cai";
        };
      };
    };
  };
};
