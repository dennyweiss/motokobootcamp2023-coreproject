import Http "http";
import Text "mo:base/Text";
import Debug "mo:base/Debug";
import HashMap "mo:base/HashMap";
import Array "mo:base/Array";
import Result "mo:base/Result";
import Principal "mo:base/Principal";
import Environment "../support/Environment";

actor Webpage {
  public type HttpRequest = Http.HttpRequest;
  public type HttpResponse = Http.HttpResponse;

  stable var environment : Text = "local";
  let guard = Environment.PrincipalGuard([{
    name = "local";
    principals = [
      "rrkah-fqaaa-aaaaa-aaaaq-cai",
    ];
  }]);

  stable var page_content : Text = "Initial content";

  public query func http_request(req : HttpRequest) : async HttpResponse {
    let response = {
      body = Text.encodeUtf8(page_content);
      headers = [];
      status_code = 200 : Nat16;
      streaming_strategy = null;
    };

    return response;
  };
  
  public shared ({ caller }) func updateContent(new_page_content : Text) : async () {
    let pricipalString = Principal.toText(caller);
    Debug.print(debug_show (caller));
    Debug.print(debug_show (environment));
    Debug.print(debug_show (guard.allowAccess(environment,pricipalString)));
    assert(guard.allowAccess(environment,pricipalString));
    page_content := new_page_content;
  };

};
