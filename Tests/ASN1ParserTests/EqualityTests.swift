import XCTest
@testable import ASN1Parser

/// Equatable no Values
final class EqualityTests: XCTestCase {
  func testBooleanEquality() throws {
    let bool1 = ASN1Boolean(false)
    let bool2 = try DERParser.parse(der: Data([DERParser.Tag.boolean.rawValue, 0x01, 0x00]))
    let bool3 = ASN1Boolean(true)
    let bool4 = try DERParser.parse(der: Data([DERParser.Tag.boolean.rawValue, 0x01, 0x01]))
    
    XCTAssert(bool2 is ASN1Boolean)
    XCTAssert(bool4 is ASN1Boolean)
    
    if let bool2 = bool2 as? ASN1Boolean, let bool4 = bool4 as? ASN1Boolean {
      XCTAssertEqual(bool1, bool2)
      XCTAssertNotEqual(bool1, bool3)
      XCTAssertNotEqual(bool1, bool4)
      
      XCTAssertNotEqual(bool2, bool3)
      XCTAssertNotEqual(bool2, bool4)
      
      XCTAssertEqual(bool3, bool4)
    }
  }

  func testIntegerEquality() throws {
    let int1 = ASN1Integer(42)
    let int2 = try ASN1Integer(der: Data([0x2A]))
    let int3 = ASN1Integer(-5)
    let int4 = try ASN1Integer(der: Data([0x85]))
    
    XCTAssertEqual(int1, int2)
    XCTAssertNotEqual(int1, int3)
    XCTAssertNotEqual(int1, int4)
    
    XCTAssertNotEqual(int2, int3)
    XCTAssertNotEqual(int2, int4)
    
    XCTAssertEqual(int3, int4)
  }

  func testNullEquality() throws {
    XCTAssertEqual(ASN1Null(), try ASN1Null(der: Data()))
  }
  
  func testObjectIdentifierEquality() throws {
    let oid1 = try ASN1ObjectIdentifier(id: "1.2.840.10045.3.1.7")
    let oid2 = try ASN1ObjectIdentifier(nodes: [1, 2, 840, 10045, 3, 1, 7])
    
    let oid3 = try ASN1ObjectIdentifier(nodes: [1, 39, 840, 10045, 3, 1])
    let oid4 = try DERParser.parse(der: Data([DERParser.Tag.objectIdentifier.rawValue, 0x07, 0x4F, 0x86, 0x48, 0xCE, 0x3D, 0x03, 0x01]))
    XCTAssert(oid4 is ASN1ObjectIdentifier)
    if let oid4 = oid4 as? ASN1ObjectIdentifier {
      XCTAssertEqual(oid1, oid2)
      XCTAssertNotEqual(oid1, oid3)
      XCTAssertNotEqual(oid1, oid4)
      
      XCTAssertNotEqual(oid2, oid3)
      XCTAssertNotEqual(oid2, oid4)
      
      XCTAssertEqual(oid3, oid4)
    }
  }
  
  func testSequenceEquality() throws {
    let seq = ASN1Sequence(ASN1Boolean(false))
    let seq2 = try DERParser.parse(der: Data([
      DERParser.Tag.sequence.rawValue, 0x03,
        DERParser.Tag.boolean.rawValue, 0x01, 0x00
    ]))
    let seq3 = ASN1Sequence(ASN1Boolean(false), ASN1Boolean(true), ASN1Boolean(false))
    let seq4 = try DERParser.parse(der: Data([
      DERParser.Tag.sequence.rawValue, 0x09,
        DERParser.Tag.boolean.rawValue, 0x01, 0x00,
        DERParser.Tag.boolean.rawValue, 0x01, 0x01,
        DERParser.Tag.boolean.rawValue, 0x01, 0x00
    ]))
    
    XCTAssert(seq2 is ASN1Sequence)
    XCTAssert(seq4 is ASN1Sequence)
    
    if let seq2 = seq2 as? ASN1Sequence, let seq4 = seq4 as? ASN1Sequence {
      XCTAssertEqual(seq, seq2)
      XCTAssertNotEqual(seq, seq3)
      XCTAssertNotEqual(seq, seq4)
      
      XCTAssertNotEqual(seq2, seq3)
      XCTAssertNotEqual(seq2, seq4)
      
      XCTAssertEqual(seq3, seq4)
    }
  }
}
