import Source "mo:uuid/async/SourceV4";
import UUID "mo:uuid/UUID";

module UUIDFactory {
  public func create() : async Text {
    let g = Source.Source();
    UUID.toText(await g.new());
  }  
}