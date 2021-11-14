import XCTest
@testable import ASN1Parser

final class FullParseTests: XCTestCase {
  func testParsingECPublicKeyDER() throws {
    guard let derData = Data(base64Encoded: "MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEQPtmXeh4gkzq30Zq3LXdgcl39fgCOBRZExhNWgZTSv5NTvbRoZNx28Ln/+Wtkfc42nWdunurluAeMPr0BrnLtA==")
    else {
      XCTFail()
      return
    }
    
    let tree = try DERParser.parse(der: derData)
    print(tree)
  }
  
  func testRandomDER() throws {
    let derData = Data([
      DERParser.Tag.sequence.rawValue, 0x13,
        DERParser.Tag.sequence.rawValue, 0x05,
          DERParser.Tag.null.rawValue, 0x00,
          DERParser.Tag.integer.rawValue, 0x01, 0x85,
        DERParser.Tag.boolean.rawValue, 0x01, 0x01,
        DERParser.Tag.objectIdentifier.rawValue, 0x07, 0x2A, 0x86, 0x48, 0xCE, 0x3D, 0x02, 0x01,
    ])
    
    let tree = try DERParser.parse(der: derData)
    print(tree)
  }
}
