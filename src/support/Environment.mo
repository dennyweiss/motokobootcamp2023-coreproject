import Array "mo:base/Array";
import Debug "mo:base/Debug";
import Text "mo:base/Text";

module Environment {
  public type Environment = {
    name : Text;
    principals : [Text];
  };

  public type Access = {
    #allowed;
    #denied;
  };

  public class PrincipalGuard(
    environments : [Environment],
  ) {
    let _environments = environments;

    public func checkAccess(environment : Text, principal : Text) : Access {
      func findEnvironment(item : Environment) : Bool {
        environment == item.name;
      };

      let selectedEnvironment : ?Environment = Array.find<Environment>(
        _environments,
        findEnvironment,
      );

      let supportedPrinciples : [Text] = switch (selectedEnvironment) {
        case (?selectedEnvironment) selectedEnvironment.principals;
        case (null)[];
      };

      return switch (
        Array.find<Text>(supportedPrinciples, func(x) { Text.equal(x, principal) }),
      ) {
        case (?a) #allowed;
        case _ #denied;
      };

    };
  };
};
