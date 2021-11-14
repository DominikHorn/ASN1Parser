# ``ASN1Parser``

Minimalistic library for parsing ASN.1 encoded data in Swift.

## Example

Given the a DER encoded ASN.1 representation of a public key, for example as found in `.pem` files:

```swift
// Public key data blob from pem file
let pemBlob = "MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEQPtmXeh4gkzq30Zq3LXdgcl39fgCOBRZExhNWgZTSv5NTvbRoZNx28Ln/+Wtkfc42nWdunurluAeMPr0BrnLtA=="
guard let derData = Data(base64Encoded: pemBlob) else { return }

// Parse DER into ASNValue. This is a tree like structure
let tree = try DERParser.parse(derData)
```

## Topics

### Parsing Data

- ``DERParser``

### ASN.1 Value Types

- ``ASN1Value``
- ``ASN1Boolean``
- ``ASN1Integer``
- ``ASN1Null``
- ``ASN1ObjectIdentifier``
- ``ASN1Sequence``
