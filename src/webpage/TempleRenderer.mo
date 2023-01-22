import Text "mo:base/Text";
module TempleRenderer {
   public func render(content : Text) : Blob {
    return Text.encodeUtf8(
      "" 
      # "<!doctype html>" 
      # "<html class=\"no-js\" lang=\"\">" 
      # "<head>" 
      # "  <meta charset=\"utf-8\">" 
      # "  <title>Motoko Bootcamp DAO feeded Webpage</title>" 
      # "  <meta name=\"description\" content=\"\">" 
      # "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">" 
      # "" 
      # "  <meta property=\"og:title\" content=\"\">" 
      # "  <meta property=\"og:type\" content=\"\">" 
      # "  <meta property=\"og:url\" content=\"\">" 
      # "  <meta property=\"og:image\" content=\"\">" 
      # "" 
      # "  <link rel=\"icon\" href=\"data:;base64,iVBORw0KGgo=\" sizes=\"any\">" 
      # "" 
      # "  <meta name=\"theme-color\" content=\"#fafafa\">" 
      # "</head>" 
      # "" 
      # "<body style=\"font-family: sans-serif;\">" 
      # "" 
      # "  <h1 class=\"marging-bottom:32px;\">Motoko Bootcamp DAO feeded Webpage</h1>" 
      # "" 
      # "  <p>" 
      # content 
      # "</p>" 
      # "" 
      # "</body>" 
      # "" 
      # "</html>",
    );
  }; 
}