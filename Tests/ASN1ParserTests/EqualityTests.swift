import XCTest
@testable import ASN1Parser

/// Equatable no Values
final class EqualityTests: XCTestCase {
  func testBooleanEquality() throws {
    let bool1 = ASN1Boolean(false)
    var bool2: ASN1Value?
    let bool3 = ASN1Boolean(true)
    var bool4: ASN1Value?
    
    XCTAssertNoThrow(bool2 = try ASN1Parser.parse(Data([ASN1Parser.Tag.boolean.rawValue, 0x01, 0x00])))
    XCTAssertNotNil(bool2)
    XCTAssert(bool2 is ASN1Boolean)
    XCTAssertNoThrow(bool4 = try ASN1Parser.parse(Data([ASN1Parser.Tag.boolean.rawValue, 0x01, 0x01])))
    XCTAssertNotNil(bool4)
    XCTAssert(bool4 is ASN1Boolean)
    
    if let bool2 = bool2 as? ASN1Boolean, let bool4 = bool4 as? ASN1Boolean {
      XCTAssert(bool1 == bool2)
      XCTAssert(bool1 != bool3)
      XCTAssert(bool1 != bool4)
      
      XCTAssert(bool2 != bool3)
      XCTAssert(bool2 != bool4)
      
      XCTAssert(bool3 == bool4)
    }
  }
  
  func testSequenceEquality() throws {
    let seq = ASN1Sequence(ASN1Boolean(false))
    var seq2: ASN1Value?
    let seq3 = ASN1Sequence(ASN1Boolean(false), ASN1Boolean(true), ASN1Boolean(false))
    var seq4: ASN1Value?
    
    XCTAssertNoThrow(seq2 = try ASN1Parser.parse(Data([
      ASN1Parser.Tag.sequence.rawValue, 0x03,
        ASN1Parser.Tag.boolean.rawValue, 0x01, 0x00
    ])))
    XCTAssertNotNil(seq2)
    XCTAssert(seq2 is ASN1Sequence)
    XCTAssertNoThrow(seq4 = try ASN1Parser.parse(Data([
      ASN1Parser.Tag.sequence.rawValue, 0x09,
        ASN1Parser.Tag.boolean.rawValue, 0x01, 0x00,
        ASN1Parser.Tag.boolean.rawValue, 0x01, 0x01,
        ASN1Parser.Tag.boolean.rawValue, 0x01, 0x00
    ])))
    XCTAssertNotNil(seq4)
    XCTAssert(seq4 is ASN1Sequence)
    
    if let seq2 = seq2 as? ASN1Sequence, let seq4 = seq4 as? ASN1Sequence {
      XCTAssert(seq == seq2)
      XCTAssert(seq != seq3)
      XCTAssert(seq != seq4)
      
      XCTAssert(seq2 != seq3)
      XCTAssert(seq2 != seq4)
      
      XCTAssert(seq3 == seq4)
    }
  }
}
