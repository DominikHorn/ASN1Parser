# ASN1Parser
![tests](https://github.com/DominikHorn/ASN1Parser/actions/workflows/test.yml/badge.svg)
![coverage](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/DominikHorn/abb8b96dc5a9b8354fb3d70216aedc7d/raw/coverage-badge.json)

Safety first ASN.1 parsing in Swift.

## Documentation
You may import `ASN1Parser.docc` into Xcode, preview locally using `preview-doc.sh` or build a static
site doc on your own using `gen-doc.sh`. Note that this static site sadly not hostable via
github pages due to its case sensitivity.

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

Please note that the choice of implicit format specification is a deliberate
one. I believe ASN.1 is not particularily suited to be 1:1 mapped to swift
types. Therefore you will most likely have to introduce an abstraction layer,
i.e., an explicit ASN.1 format specification in addition to the swift type
defintion you'd ideally want to use throughout your remaining code. This
abstraction layer is however unnecessary IMHO, as it only consists of
boilerplate definitions and code for converting between the ASN.1 format and
your swift type. In addition to the often wasteful and messy nature of
boilerplate code, having two different abstractions for the same underlying
concept can introduce inconsistencies and thus bugs.

With implicit ASN.1 format specification, you can access ASN.1 data safely and
quicker while not having having to worry about introducing any accidental
inconsistencies in your codebase, because an additional abstraction layer won't
exist. Simply define your desired type in swift and dynamically load its
values from the decoded ASN.1 representation.

## Contributing
Pull requests are of course are highly appreciated :)
