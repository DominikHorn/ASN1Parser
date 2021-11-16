# ASN1Parser
![tests](https://github.com/DominikHorn/ASN1Parser/actions/workflows/test.yml/badge.svg)
![coverage](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/DominikHorn/abb8b96dc5a9b8354fb3d70216aedc7d/raw/coverage-badge.json)

Safety first ASN.1 parsing in Swift.

## Documentation
You may find precompiled static site documentation hosted [here](https://dominikhorn.github.io/ASN1Parser/documentation/asn1parser/).
Alternatively, you may import `ASN1Parser.docc` into Xcode, preview locally using `preview-doc.sh` or build the static
site on your own using `gen-doc.sh`.

### Quick Start
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

### Feature Overview
- **runtime safe** ASN.1 parsing - error handling enforced by the swift compiler
- **minimalistic** - only contains the features you need
- **quick and easy** to use - immediately start parsing DER or BER encoded ASN.1 without any boilerplate
- **implicit ASN.1 format specification** - no need worry about explicitely specifying the expected data format.
  Simply access values in the ASN.1 tree and dynamically receive errors if they are not available.
  This architecture prevents accidental inconsistencies, e.g., when the code defining your expected
  format is out of sync with the actual format used.

## Contributing
Pull requests are of course are highly appreciated :)
