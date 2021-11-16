# ASN1Parser

![tests](https://github.com/DominikHorn/ASN1Parser/actions/workflows/test.yml/badge.svg)
![coverage](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/DominikHorn/abb8b96dc5a9b8354fb3d70216aedc7d/raw/coverage-badge.json)


Safety first ASN.1 parsing in Swift. 

## Documentation
You may find precompiled static site documentation hosted [here](https://dominikhorn.github.io/ASN1Parser/documentation/asn1parser/).
Alternatively, you may import `ASN1Parser.docc` into Xcode, preview locally using `preview-doc.sh` or build the static
site on your own using `gen-doc.sh`.  

## Quick Start
Given the a DER encoded ASN.1 representation of a public key, for example as found in `.pem` files:

```swift
// Public key data blob from pem file
let pemBlob = "MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEQPtmXeh4gkzq30Zq3LXdgcl39fgCOBRZExhNWgZTSv5NTvbRoZNx28Ln/+Wtkfc42nWdunurluAeMPr0BrnLtA=="
guard let derData = Data(base64Encoded: pemBlob) else { return }

// Parse DER into ASN.1 value, which is a tree like structure
let tree = try DERParser.parse(derData)

// Access values within the tree
let q = try tree.asSequence[1].asBitString
```

## Contributing 

Pull requests are of course are highly appreciated :)
