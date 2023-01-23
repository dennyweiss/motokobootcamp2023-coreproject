import Principal "mo:base/Principal";


module PrincipalHelper {

  public type PrincipalStatus = {
    #isNull;
    #isAnonymous;
    #isReal;
  };


  public func evaluatePrincipalStatus(principal : ?Principal) : PrincipalStatus {
    switch (principal) {
      case (?principal) {
        if (Principal.isAnonymous(principal)) {
          return #isAnonymous;
        } else {
          return #isReal;
        };
      };
      case (null) {
        return #isNull;
      };
    };
  };

};
