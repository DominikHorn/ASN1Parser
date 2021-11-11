import XCTest
@testable import ASN1Parser

/// Equatable no Values
final class EqualityTests: XCTestCase {
  func testBooleanEquality() throws {
    let bool1 = ASN1Boolean(false)
    let bool2 = try ASN1Parser.parse(Data([ASN1Parser.Tag.boolean.rawValue, 0x01, 0x00]))
    let bool3 = ASN1Boolean(true)
    let bool4 = try ASN1Parser.parse(Data([ASN1Parser.Tag.boolean.rawValue, 0x01, 0x01]))
    
    XCTAssert(bool2 is ASN1Boolean)
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

  func testIntegerEquality() throws {
    let int1 = ASN1Integer(42)
    let int2 = try ASN1Integer(data: Data([0x2A]))
    let int3 = ASN1Integer(-5)
    let int4 = try ASN1Integer(data: Data([0x85]))
    
    XCTAssert(int1 == int2)
    XCTAssert(int1 != int3)
    XCTAssert(int1 != int4)
    
    XCTAssert(int2 != int3)
    XCTAssert(int2 != int4)
    
    XCTAssert(int3 == int4)
  }

  func testNullEquality() throws {
    XCTAssert(try ASN1Null() == ASN1Null(data: Data()))
  }
  
  // TODO(dominik) equality integer, null etc tests!
  
  func testSequenceEquality() throws {
    let seq = ASN1Sequence(ASN1Boolean(false))
    let seq2 = try ASN1Parser.parse(Data([
      ASN1Parser.Tag.sequence.rawValue, 0x03,
        ASN1Parser.Tag.boolean.rawValue, 0x01, 0x00
    ]))
    let seq3 = ASN1Sequence(ASN1Boolean(false), ASN1Boolean(true), ASN1Boolean(false))
    let seq4 = try ASN1Parser.parse(Data([
      ASN1Parser.Tag.sequence.rawValue, 0x09,
        ASN1Parser.Tag.boolean.rawValue, 0x01, 0x00,
        ASN1Parser.Tag.boolean.rawValue, 0x01, 0x01,
        ASN1Parser.Tag.boolean.rawValue, 0x01, 0x00
    ]))
    
    XCTAssert(seq2 is ASN1Sequence)
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
