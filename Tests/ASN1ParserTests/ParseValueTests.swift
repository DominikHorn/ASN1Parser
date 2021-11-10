import XCTest
@testable import ASN1Parser

/// Parsing values from binary data
final class ParseValueTests: XCTestCase {
  func testSafelyParseGarbage() throws {
    // TODO(dominik): add more garbage inputs
    XCTAssertThrowsError(try ASN1Parser.parse(Data([])))
    XCTAssertThrowsError(try ASN1Parser.parse(Data([0x00])))
    XCTAssertThrowsError(try ASN1Parser.parse(Data([0x00,0x01, 0x00])))
    XCTAssertThrowsError(try ASN1Parser.parse(Data([0x02,0x00])))
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
  
  func testParseSequence() throws {
    var val: ASN1Value?
    
    // single element in sequence
    XCTAssertNoThrow(val = try ASN1Parser.parse(Data([
      ASN1Parser.Tag.sequence.rawValue, 0x03,
        ASN1Parser.Tag.boolean.rawValue, 0x01, 0x01
    ])))
    XCTAssertNotNil(val)
    XCTAssert(val is ASN1Sequence)
    if let sequence = val as? ASN1Sequence {
      XCTAssert(sequence.values.count == 1)
      XCTAssert(sequence.values.first is ASN1Boolean)
      if let bool = sequence.values.first as? ASN1Boolean {
        XCTAssert(true == bool.swiftValue)
      }
    }
    
    // multiple elements in sequence
    XCTAssertNoThrow(val = try ASN1Parser.parse(Data([
      ASN1Parser.Tag.sequence.rawValue, 0x09,
        ASN1Parser.Tag.boolean.rawValue, 0x01, 0x00,
        ASN1Parser.Tag.boolean.rawValue, 0x01, 0x01,
        ASN1Parser.Tag.boolean.rawValue, 0x01, 0x00
    ])))
    XCTAssertNotNil(val)
    XCTAssert(val is ASN1Sequence)
    if let sequence = val as? ASN1Sequence {
      XCTAssert(sequence.values.count == 3)
      sequence.values.enumerated().forEach { i, val in
        XCTAssert(val is ASN1Boolean)
        if let bool = val as? ASN1Boolean {
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

