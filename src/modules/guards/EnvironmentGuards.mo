import Array "mo:base/Array";
import Debug "mo:base/Debug";
import Text "mo:base/Text";
import Buffer "mo:base/Buffer";
import { nyi } "mo:base/Prelude";
import Environment "../Environment";
import Option "mo:base/Option";
import Principal "mo:base/Principal";

module EnvironmentGuards {

  public type EnvironmentDefinition = {
    environmentType : Environment.EnvironmentType;
    principals : [Text]; // @todo consider using Principal
  };

  public type AccessPermission = {
    #allowed;
    #denied;
  };

  public class EnvironmentPrincipalGard(
    // environmentDefinitions : ?[EnvironmentDefinition]
  ) {
    var _environmentDefinitions : [EnvironmentDefinition] = [];

    public func registerEnvironment(environment : EnvironmentDefinition) {
      let environmentDefinitionsBuffer = Buffer.fromArray<EnvironmentDefinition>(_environmentDefinitions);
      environmentDefinitionsBuffer.add(environment);
      _environmentDefinitions := Buffer.toArray(environmentDefinitionsBuffer);
    };

    public func isAccess(
      principal : Principal,
      environmentType : Environment.EnvironmentType,
      accessPermission : AccessPermission,
    ) : Bool {
      let selectedEnvironment : ?EnvironmentDefinition = Array.find<EnvironmentDefinition>(
        _environmentDefinitions,
        func(environmentDefinition : EnvironmentDefinition) {
          environmentType == environmentDefinition.environmentType;
        },
      );

      let supportedPrinciples : [Text] = switch (selectedEnvironment) {
        case (?selectedEnvironment) selectedEnvironment.principals;
        case (null)[];
      };

      let result = switch (
        Array.find<Text>(supportedPrinciples, func(x) { Text.equal(x, Principal.toText(principal)) }),
      ) {
        case (?a) #allowed;
        case _ #denied;
      };

      return switch (result) {
        case (#allowed) true;
        case (#denied) false;
      };
    };
  };

};
