import Bool "mo:base/Bool";
import Buffer "mo:base/Buffer";
import Text "mo:base/Text";
import Debug "mo:base/Debug";
import HashMap "mo:base/HashMap";
import Array "mo:base/Array";
import Result "mo:base/Result";
import Principal "mo:base/Principal";
import EnvironmentGuards "../modules/guards/EnvironmentGuards";
import PrincipleTypeGuard "../modules/guards/PrincipleTypeGuard";
import Environment "../modules/Environment";
import Http "Http";
import HashTree "HashTree";
import TempleRenderer "TempleRenderer";
import CanisterResolver "../modules/CanisterResolver";

actor Webpage {
  //////////////////////////////////////////////////////////////////////////////
  // Environment Guards ////////////////////////////////////////////////////////
  stable var environment : Environment.EnvironmentType = #local;
  let environmentPrincipalGard = EnvironmentGuards.EnvironmentPrincipalGard();
  environmentPrincipalGard.registerEnvironment({
    environmentType = #local;
    principals = [CanisterResolver.resolve(#local, #dao)];
  });
  environmentPrincipalGard.registerEnvironment({
    environmentType = #ic;
    principals = [CanisterResolver.resolve(#ic, #dao)];
  });

  public shared ({ caller }) func setEnvironment(environmentName : Environment.EnvironmentType) : async Environment.EnvironmentType {
    assert (PrincipleTypeGuard.is(caller, #admin));
    environment := environmentName;
    environment;
  };

  //////////////////////////////////////////////////////////////////////////////
  // HTTP Handler //////////////////////////////////////////////////////////////
  public type HttpRequest = Http.HttpRequest;
  public type HttpResponse = Http.HttpResponse;

  public query func http_request(req : HttpRequest) : async HttpResponse {
    let response = {
      body = pageContent;
      headers = [
        ("content-type", "text/html;charset=utf-8"),
        HashTree.certification_header(pageContent),
      ];
      status_code = 200 : Nat16;
      streaming_strategy = null;
    };

    return response;
  };
  //////////////////////////////////////////////////////////////////////////////
  // Dynamic Content ///////////////////////////////////////////////////////////
  stable var pageContent : Blob = TempleRenderer.render("Some initial content");
  public shared ({ caller }) func updateWebpageContent(newPageContent : Text) : async () {
    assert (environmentPrincipalGard.isAccess(caller, environment, #allowed));
    pageContent := TempleRenderer.render(newPageContent);
  };

  public shared ({ caller }) func getContent() : async Blob {
    assert (PrincipleTypeGuard.is(caller, #admin));
    return pageContent;
  };
};
