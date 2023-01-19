import Http "http";
import Text "mo:base/Text";

actor {
  public type HttpRequest = Http.HttpRequest;
  public type HttpResponse = Http.HttpResponse;

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

  public func update_page_content(new_page_content : Text) {
    // @todo gate write access to dao canister id
    page_content := new_page_content;
  };
};
