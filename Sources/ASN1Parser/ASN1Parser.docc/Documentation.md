# ``ASN1Parser``

## Overview

A small library for parsing ASN1 encoded data.

## Example
Given the following base64 encoded ASN1 representation of a public key, e.g., as found in `.pem` files:
```swift
// Public key data blob from pem file
let pemBlob = "MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEQPtmXeh4gkzq30Zq3LXdgcl39fgCOBRZExhNWgZTSv5NTvbRoZNx28Ln/+Wtkfc42nWdunurluAeMPr0BrnLtA=="
guard let derData = Data(base64Encoded: pemBlob) else { return }

// Parse DER into ASNValue. This is a tree like structure
let tree = try ASN1Parser.parseDER(derData)
```

## Topics

### Parsing Data

- ``ASN1Parser``

### ASN1 Values

- ``ASN1Value``
- ``ASN1Boolean``
- ``ASN1Integer``
- ``ASN1Null``
- ``ASN1ObjectIdentifier``
- ``ASN1Sequence``
