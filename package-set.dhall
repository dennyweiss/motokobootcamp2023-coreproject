let upstream = https://github.com/dfinity/vessel-package-set/releases/download/mo-0.7.5-20230118/package-set.dhall sha256:3898b1cb55eddc69be8edf5c5edae6c4e12032382ae762dcda42fee30cd9cc5b
let icbase = https://github.com/dfinity/vessel-package-set/releases/download/mo-0.7.3-20221102/package-set.dhall
let icos = https://github.com/internet-computer/base-package-set/releases/download/moc-0.7.4/package-set.dhall sha256:3a20693fc597b96a8c7cf8645fda7a3534d13e5fbda28c00d01f0b7641efe494

let Package =
    { name : Text, version : Text, repo : Text, dependencies : List Text }

let additions = [
  { name = "array"
  , version = "v0.2.1"
  , repo = "https://github.com/aviate-labs/array.mo"
  , dependencies = [ "base-0.7.3" ] : List Text
  },
  { name = "crypto"
  , version = "v0.3.1"
  , repo = "https://github.com/aviate-labs/crypto.mo"
  , dependencies = [ "base-0.7.3", "encoding" ]
  },
  { name = "encoding"
  , version = "v0.4.1"
  , repo = "https://github.com/aviate-labs/encoding.mo"
  , dependencies = [ "base-0.7.3", "array" ]
  },
  { name = "hash"
  , version = "v0.1.1"
  , repo = "https://github.com/aviate-labs/hash.mo"
  , dependencies = [ "base-0.7.3", "array" ]
  },
  { name = "principal"
  , repo = "https://github.com/aviate-labs/principal.mo"
  , version = "v0.2.6"
  , dependencies = [ "array", "base-0.7.3", "crypto", "encoding", "hash" ]
  },
  { name = "uuid"
  , repo = "https://github.com/aviate-labs/uuid.mo"
  , version = "v0.2.1"
  , dependencies = [ "array", "base-0.7.3", "crypto", "encoding", "hash", "io" ]
  },
  { name = "io"
  , version = "v0.3.2"
  , repo = "https://github.com/aviate-labs/io.mo"
  , dependencies = [ "base-0.7.3" ]
  },
  { name = "motoko-hash-map"
  , version = "v7.0.0"
  , repo = "https://github.com/ZhenyaUsenko/motoko-hash-map"
  , dependencies = [ "base" ]
  },
]

in  upstream # icbase # icos # additions # additions
