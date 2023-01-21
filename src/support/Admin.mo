import Array "mo:base/Array";
import Principal "mo:base/Principal";

module Admin {
  func adminList() : [Principal] {
    [
      Principal.fromText("4wtdz-zhyfn-46p4d-apw5i-weord-ktvsf-n4jge-qqsf6-ftski-i7fr3-pqe"),
    ];
  };

  public func isAdmin(principal : Principal) : Bool {

    return switch (Array.find<Principal>(adminList(), func(x) { x == principal })) {
      case (?a) true;
      case _ false;
    };
  };
};
