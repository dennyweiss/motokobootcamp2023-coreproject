import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export type EnvironmentType = { 'ic' : null } |
  { 'local' : null };
export type HeaderField = [string, string];
export interface HttpRequest {
  'url' : string,
  'method' : string,
  'body' : Uint8Array,
  'headers' : Array<HeaderField>,
}
export interface HttpResponse {
  'body' : Uint8Array,
  'headers' : Array<HeaderField>,
  'streaming_strategy' : [] | [StreamingStrategy],
  'status_code' : number,
}
export type StreamingCallback = ActorMethod<
  [StreamingCallbackToken],
  StreamingCallbackResponse
>;
export interface StreamingCallbackResponse {
  'token' : [] | [StreamingCallbackToken],
  'body' : Uint8Array,
}
export interface StreamingCallbackToken {
  'key' : string,
  'index' : bigint,
  'content_encoding' : string,
}
export type StreamingStrategy = {
    'Callback' : {
      'token' : StreamingCallbackToken,
      'callback' : StreamingCallback,
    }
  };
export interface _SERVICE {
  'getContent' : ActorMethod<[], Uint8Array>,
  'http_request' : ActorMethod<[HttpRequest], HttpResponse>,
  'setEnvironment' : ActorMethod<[EnvironmentType], EnvironmentType>,
  'updateWebpageContent' : ActorMethod<[string], undefined>,
}
