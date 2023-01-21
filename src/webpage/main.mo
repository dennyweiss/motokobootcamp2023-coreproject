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
  public type HttpRequest = Http.HttpRequest;
  public type HttpResponse = Http.HttpResponse;

  stable var page_content : Text = "Initial content";
  stable var environment : Text = "local";

  let admins : [Principal] = [Principal.fromText("4wtdz-zhyfn-46p4d-apw5i-weord-ktvsf-n4jge-qqsf6-ftski-i7fr3-pqe")];
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

  public shared ({ caller }) func changeEnvironment(environmentName : Text) : async () {
    assert (Admin.isAdmin(caller, admins));
    environment := environmentName;
    ();
  };

  public func currentEnvironment() : async Text {
    return environment;
  };

  public query func http_request(req : HttpRequest) : async HttpResponse {
    let response = {
      body = Text.encodeUtf8(page_content);
      headers = [];
      status_code = 200 : Nat16;
      streaming_strategy = null;
    };

    return response;
  };

  public shared ({ caller }) func updateWebpageContent(new_page_content : Text) : async () {
    assert (guard.allowAccess(environment, Principal.toText(caller)));
    page_content := new_page_content;
  };

};
