import Array "mo:base/Array";
import Principal "mo:base/Principal";
import { nyi } "mo:base/Prelude";

module PrincipleTypeGuard {

  type PrincipalType = {
    #admin;
    #user;
    #canister;
    #anonymous;
  };

  func supportedAdmins() : [Principal] {
    [
      Principal.fromText("4wtdz-zhyfn-46p4d-apw5i-weord-ktvsf-n4jge-qqsf6-ftski-i7fr3-pqe"),
    ];
  };

  func isAdmin(principal : Principal) : Bool {
    return switch (Array.find<Principal>(supportedAdmins(), func(x) { x == principal })) {
      case (?a) true;
      case _ false;
    };
  };

  public func is( principal: Principal, expect: PrincipalType ) : Bool {
    switch(expect) {
      case(#admin) { 
          return isAdmin(principal);
       };
      case(#user) {nyi()};
      case(#canister) {nyi()};
      case(#anonymous) {nyi()};
    };
  }

};
