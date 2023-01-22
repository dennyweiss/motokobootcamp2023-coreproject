import AccountIdentifier "mo:principal/AccountIdentifier";
import Array "mo:base/Array";
import Text "mo:base/Text";
import Nat8 "mo:base/Nat8";

module AccountHelper {
  public func inspectAccount(principal : Principal) : Text {
    let accountIdentifier : [Nat8] = AccountIdentifier.fromPrincipal(principal, null);
    let accountIdentifierText : [Text] = Array.map<Nat8, Text>(
      accountIdentifier,
      func(item) {
        Nat8.toText(item);
      },
    );
    let accountIdentifierString : Text = Text.join("", accountIdentifierText.vals());
    accountIdentifierString;
  };
};
