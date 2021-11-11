import XCTest
@testable import ASN1Parser

import BigInt

/// Constructing values programatically
final class ConstructValueTests: XCTestCase {
  func testConstructBoolean() {
    let bool = ASN1Boolean(true)
    XCTAssert(true == bool.swiftValue)
    
    let bool2 = ASN1Boolean(false)
    XCTAssert(false == bool2.swiftValue)
  }
  
  func testConstructInteger() throws {
    let int = ASN1Integer(1337)
    XCTAssert(1337 == int.swiftValue)
    
    let int2 = ASN1Integer(-50)
    XCTAssert(-50 == int2.swiftValue)
    
    let longUIntData = Data([
      0x8f, 0xe2, 0x41, 0x2a, 0x08, 0xe8, 0x51, 0xa8,
      0x8c, 0xb3, 0xe8, 0x53, 0xe7, 0xd5, 0x49, 0x50,
      0xb3, 0x27, 0x8a, 0x2b, 0xcb, 0xea, 0xb5, 0x42,
      0x73, 0xea, 0x02, 0x57, 0xcc, 0x65, 0x33, 0xee,
      0x88, 0x20, 0x61, 0xa1, 0x18, 0x56, 0xc1, 0x24,
      0x18, 0xe3, 0xa8, 0x08, 0xd3, 0xbe, 0xd9, 0x31,
      0xf3, 0x37, 0x0b, 0x94, 0xb9, 0xcc, 0x43, 0x08,
      0x0b, 0x70, 0x24, 0xf7, 0x9c, 0xb1, 0x8d, 0x5d,
      0xd6, 0x6d, 0x82, 0xd0, 0x54, 0x09, 0x84, 0xf8,
      0x9f, 0x97, 0x01, 0x75, 0x05, 0x9c, 0x89, 0xd4,
      0xd5, 0xc9, 0x1e, 0xc9, 0x13, 0xd7, 0x2a, 0x6b,
      0x30, 0x91, 0x19, 0xd6, 0xd4, 0x42, 0xe0, 0xc4,
      0x9d, 0x7c, 0x92, 0x71, 0xe1, 0xb2, 0x2f, 0x5c,
      0x8d, 0xee, 0xf0, 0xf1, 0x17, 0x1e, 0xd2, 0x5f,
      0x31, 0x5b, 0xb1, 0x9c, 0xbc, 0x20, 0x55, 0xbf,
      0x3a, 0x37, 0x42, 0x45, 0x75, 0xdc, 0x90, 0x65
    ])
    let int3 = ASN1Integer(BigInt(longUIntData))
    XCTAssert(BigInt(longUIntData) == int3.swiftValue)
  }
  
                   
  func testConstructSequence() {
    XCTAssertThrowsError(try ASN1Sequence([]))
    
    let seq = ASN1Sequence(ASN1Boolean(false))
    XCTAssert(seq.values.count == 1)
    XCTAssert(seq.values.first is ASN1Boolean)
    if let bool = seq.values.first as? ASN1Boolean {
      XCTAssert(false == bool.swiftValue)
    }
    
    var seq2: ASN1Sequence?
    XCTAssertNoThrow(seq2 = try ASN1Sequence([ASN1Boolean(false)]))
    XCTAssertNotNil(seq2)
    XCTAssert(seq == seq2)
    
    let seq3 = ASN1Sequence(ASN1Boolean(true), ASN1Boolean(false), ASN1Boolean(false))
    XCTAssert(seq3.values.count == 3)
    seq3.values.forEach { val in
      XCTAssert(val is ASN1Boolean)
    }
    
    var seq4: ASN1Sequence?
    XCTAssertNoThrow(seq4 = try ASN1Sequence([ASN1Boolean(true), ASN1Boolean(false)]))
    XCTAssertNotNil(seq4)
    XCTAssert(seq3 != seq4)
    
    var seq5: ASN1Sequence?
    XCTAssertNoThrow(seq5 = try ASN1Sequence([ASN1Boolean(true), ASN1Boolean(false), ASN1Boolean(false)]))
    XCTAssertNotNil(seq5)
    XCTAssert(seq3 == seq5)
  }
}
