import XCTest
@testable import ASN1Parser

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
    XCTAssertNoThrow(val = try ASN1Parser.parse(Data([0x01, 0x01, 0x00])))
    XCTAssertNotNil(val)
    XCTAssert(val is ASN1Boolean)
    if let bool = val as? ASN1Boolean {
      XCTAssert(false == bool.value)
    }
    
    // true value
    XCTAssertNoThrow(val = try ASN1Parser.parse(Data([0x01, 0x01, 0x01])))
    XCTAssertNotNil(val)
    XCTAssert(val is ASN1Boolean)
    if let bool = val as? ASN1Boolean {
      XCTAssert(true == bool.value)
    }
    
    // failed parsing
    XCTAssertThrowsError(try ASN1Parser.parse(Data([0x01, 0x01, 0x02])))
    XCTAssertThrowsError(try ASN1Parser.parse(Data([0x01, 0x01, 0x05])))
    XCTAssertThrowsError(try ASN1Parser.parse(Data([0x01, 0x01, 0x10])))
    XCTAssertThrowsError(try ASN1Parser.parse(Data([0x01, 0x01, 0xFE])))
    XCTAssertThrowsError(try ASN1Parser.parse(Data([0x01, 0x01, 0xFF])))
  }
}

