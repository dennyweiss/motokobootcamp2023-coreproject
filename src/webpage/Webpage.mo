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

actor Webpage {
  //////////////////////////////////////////////////////////////////////////////
  // Environment Guards ////////////////////////////////////////////////////////
  stable var environment : Environment.EnvironmentType = #local;
  let environmentPrincipalGard = EnvironmentGuards.EnvironmentPrincipalGard();
  environmentPrincipalGard.registerEnvironment({
    environmentType = #local;
    principals = ["rrkah-fqaaa-aaaaa-aaaaq-cai"];
  });
  environmentPrincipalGard.registerEnvironment({
    environmentType = #ic;
    principals = [];
  });

  public shared ({ caller }) func setEnvironment(environmentName : Environment.EnvironmentType) : async () {
    assert (PrincipleTypeGuard.is(caller, #admin));
    environment := environmentName;
    ();
  };

  public query func getEnvironment() : async Environment.EnvironmentType {
    environment;
  };

  //////////////////////////////////////////////////////////////////////////////
  // HTTP Handler //////////////////////////////////////////////////////////////
  public type HttpRequest = Http.HttpRequest;
  public type HttpResponse = Http.HttpResponse;

  public query func http_request(req : HttpRequest) : async HttpResponse {
    let response = {
      body = Text.encodeUtf8(page_content);
      headers = [];
      status_code = 200 : Nat16;
      streaming_strategy = null;
    };

    return response;
  };

  //////////////////////////////////////////////////////////////////////////////
  // Dynamic Content ///////////////////////////////////////////////////////////
  stable var page_content : Text = "Initial content";
  public shared ({ caller }) func updateWebpageContent(new_page_content : Text) : async () {
    assert (environmentPrincipalGard.isAccess(caller, environment, #allowed));
    page_content := new_page_content;
  };

  public query func getContent() : async Text {
    return page_content;
  };
};
