import Http "http";
import Text "mo:base/Text";
import Debug "mo:base/Debug";
import HashMap "mo:base/HashMap";
import Array "mo:base/Array";
import Result "mo:base/Result";
import Principal "mo:base/Principal";
import Environment "../support/Environment";
import Bool "mo:base/Bool";
import Admin "../support/Admin";
import Buffer "mo:base/Buffer";

actor Webpage {
  //////////////////////////////////////////////////////////////////////////////
  // Environment Guards ////////////////////////////////////////////////////////
  stable var environment : Text = "local";
  let environments : [Environment.Environment] = [
    {
      name = "local";
      principals = [
        "rrkah-fqaaa-aaaaa-aaaaq-cai",
      ];
    },
    { name = "ic"; principals = [] },
  ];
  let guard = Environment.PrincipalGuard(environments);

  public shared ({ caller }) func setEnvironment(environmentName : Text) : async () {
    assert (Admin.isAdmin(caller));
    environment := environmentName;
    ();
  };

  public func getEnvironment() : async Text {
    return environment;
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
    assert (guard.allowAccess(environment, Principal.toText(caller)));
    page_content := new_page_content;
  };

  public query func getContent() : async Text {
    return page_content;
  };
};
