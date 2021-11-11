import XCTest
@testable import ASN1Parser

import BigInt

/// Parsing values from binary data
final class ParseValueTests: XCTestCase {
  func testSafelyParseGarbage() throws {
    // TODO(dominik): add more garbage inputs
    XCTAssertThrowsError(try ASN1Parser.parse(Data([])))
    XCTAssertThrowsError(try ASN1Parser.parse(Data([0x00])))
    XCTAssertThrowsError(try ASN1Parser.parse(Data([0x00,0x01, 0x00])))
    XCTAssertThrowsError(try ASN1Parser.parse(Data([0x02,0x00])))
  }
  
  func testParseLength() throws {
    XCTAssertNoThrow(try ASN1Parser.parse(Data([ASN1Parser.Tag.integer.rawValue, 0x01, 0xFF])))
    XCTAssertNoThrow(try ASN1Parser.parse(Data([ASN1Parser.Tag.integer.rawValue, 0x03, 0x00, 0xFF, 0xFF])))
    
    // cases that should fail
    XCTAssertThrowsError(try ASN1Parser.parse(Data([ASN1Parser.Tag.integer.rawValue, 0x00, 0x02])))
    XCTAssertThrowsError(try ASN1Parser.parse(Data([ASN1Parser.Tag.integer.rawValue, 0x02, 0x02])))
    XCTAssertThrowsError(try ASN1Parser.parse(Data([ASN1Parser.Tag.integer.rawValue, 0x03, 0x02])))
    XCTAssertThrowsError(try ASN1Parser.parse(Data([ASN1Parser.Tag.integer.rawValue, 0x01])))
  }
  
  func testParseBoolean() throws {
    var val: ASN1Value?
    
    // false value
    XCTAssertNoThrow(val = try ASN1Parser.parse(Data([ASN1Parser.Tag.boolean.rawValue, 0x01, 0x00])))
    XCTAssertNotNil(val)
    XCTAssert(val is ASN1Boolean)
    if let bool = val as? ASN1Boolean {
      XCTAssert(false == bool.swiftValue)
    }
    
    // true value
    XCTAssertNoThrow(val = try ASN1Parser.parse(Data([ASN1Parser.Tag.boolean.rawValue, 0x01, 0x01])))
    XCTAssertNotNil(val)
    XCTAssert(val is ASN1Boolean)
    if let bool = val as? ASN1Boolean {
      XCTAssert(true == bool.swiftValue)
    }
    
    // failed parsing wrong bool values
    XCTAssertThrowsError(try ASN1Parser.parse(Data([ASN1Parser.Tag.boolean.rawValue, 0x01, 0x02])))
    XCTAssertThrowsError(try ASN1Parser.parse(Data([ASN1Parser.Tag.boolean.rawValue, 0x01, 0x05])))
    XCTAssertThrowsError(try ASN1Parser.parse(Data([ASN1Parser.Tag.boolean.rawValue, 0x01, 0x10])))
    XCTAssertThrowsError(try ASN1Parser.parse(Data([ASN1Parser.Tag.boolean.rawValue, 0x01, 0xFE])))
    XCTAssertThrowsError(try ASN1Parser.parse(Data([ASN1Parser.Tag.boolean.rawValue, 0x01, 0xFF])))
  }
  
  func testParseInteger() throws {
    var val: ASN1Value?
    
    XCTAssertNoThrow(val = try ASN1Parser.parse(Data([ASN1Parser.Tag.integer.rawValue, 0x01, 0x03])))
    XCTAssertNotNil(val)
    XCTAssert(val is ASN1Integer)
    if let int = val as? ASN1Integer {
      XCTAssert(3 == int.swiftValue)
    }

    XCTAssertNoThrow(val = try ASN1Parser.parse(Data([ASN1Parser.Tag.integer.rawValue, 0x01, 0x85])))
    XCTAssertNotNil(val)
    XCTAssert(val is ASN1Integer)
    if let int = val as? ASN1Integer {
      XCTAssert(-5 == int.swiftValue)
    }
    
    let longUIntData: [UInt8] = [
      0x8f, 0xe2, 0x41, 0x2a, 0x08, 0xe8, 0x51, 0xa8,
      0x8c, 0xb3, 0xe8, 0x53, 0xe7, 0xd5, 0x49, 0x50,
      0xb3, 0x27, 0x8a, 0x2b, 0xcb, 0xea, 0xb5, 0x42,
      0x73, 0xea, 0x02, 0x57, 0xcc, 0x65, 0x33, 0xee,
      0x88, 0x20, 0x61, 0xa1, 0x17, 0x56, 0xc1, 0x24,
      0x18, 0xe3, 0xa8, 0x08, 0xd3, 0xbe, 0xd9, 0x31,
      0xf3, 0x37, 0x0b, 0x94, 0xb8, 0xcc, 0x43, 0x08,
      0x0b, 0x70, 0x24, 0xf7, 0x9c, 0xb1, 0x8d, 0x5d,
      0xd6, 0x6d, 0x82, 0xd0, 0x54, 0x09, 0x84, 0xf8,
      0x9f, 0x97, 0x01, 0x75, 0x05, 0x9c, 0x89, 0xd4,
      0xd5, 0xc9, 0x1e, 0xc9, 0x13, 0xd7, 0x2a, 0x6b,
      0x30, 0x91, 0x19, 0xd6, 0xd4, 0x42, 0xe0, 0xc4,
      0x9d, 0x7c, 0x92, 0x71, 0xe1, 0xb2, 0x2f, 0x5c,
      0x8d, 0xee, 0xf0, 0xf1, 0x17, 0x1e, 0xd2, 0x5f,
      0x31, 0x5b, 0xb1, 0x9c, 0xbc, 0x20, 0x55, 0xbf,
      0x3a, 0x37, 0x42, 0x45, 0x75, 0xdc, 0x90, 0x65]
    XCTAssertNoThrow(val = try ASN1Parser.parse(Data([
      ASN1Parser.Tag.integer.rawValue, 0x81, 0x81, 0x00
    ] + longUIntData)))
    XCTAssertNotNil(val)
    XCTAssert(val is ASN1Integer)
    if let int = val as? ASN1Integer {
      let referenceVal = BigInt(sign: .plus, magnitude: BigUInt(Data(longUIntData)))
      XCTAssert(referenceVal == int.swiftValue)
    }
  }
  
  func testParseNull() throws {
    var val: ASN1Value?
    
    XCTAssertNoThrow(val = try ASN1Parser.parse(Data([ASN1Parser.Tag.null.rawValue, 0x00])))
    XCTAssertNotNil(val)
    XCTAssert(val is ASN1Null)
    
    // failed parsing wrong bool values
    XCTAssertThrowsError(try ASN1Parser.parse(Data([ASN1Parser.Tag.null.rawValue, 0x01, 0x00])))
  }
  
  func testParseSequence() throws {
    // single element in sequence
    let val = try ASN1Parser.parse(Data([
      ASN1Parser.Tag.sequence.rawValue, 0x03,
        ASN1Parser.Tag.boolean.rawValue, 0x01, 0x01
    ]))
    XCTAssert(val is ASN1Sequence)
    if let sequence = val as? ASN1Sequence {
      XCTAssert(sequence.values.count == 1)
      XCTAssert(sequence.values.first is ASN1Boolean)
      if let bool = sequence.values.first as? ASN1Boolean {
        XCTAssert(true == bool.swiftValue)
      }
    }
    
    // multiple elements in sequence
    let val2 = try ASN1Parser.parse(Data([
      ASN1Parser.Tag.sequence.rawValue, 0x09,
        ASN1Parser.Tag.boolean.rawValue, 0x01, 0x00,
        ASN1Parser.Tag.boolean.rawValue, 0x01, 0x01,
        ASN1Parser.Tag.boolean.rawValue, 0x01, 0x00
    ]))
    XCTAssert(val2 is ASN1Sequence)
    if let sequence = val2 as? ASN1Sequence {
      XCTAssert(sequence.values.count == 3)
      sequence.values.enumerated().forEach { i, bool in
        XCTAssert(bool is ASN1Boolean)
        if let bool = bool as? ASN1Boolean {
          switch i {
          case 0:
            XCTAssert(false == bool.swiftValue)
          case 1:
            XCTAssert(true == bool.swiftValue)
          case 2:
            XCTAssert(false == bool.swiftValue)
          default:
            XCTAssertFalse(true)
          }
        }
      }
    }
    
    // failed parsing - empty sequence
    XCTAssertThrowsError(try ASN1Parser.parse(Data([ASN1Parser.Tag.sequence.rawValue, 0x00])))
  }
}

