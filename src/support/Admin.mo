import Array "mo:base/Array";

module Admin {
  public func isAdmin(principal : Principal, admins : [Principal]) : Bool {
    return switch (Array.find<Principal>(admins, func(x) { x == principal })) {
      case (?a) true;
      case _ false;
    };
  };
};
