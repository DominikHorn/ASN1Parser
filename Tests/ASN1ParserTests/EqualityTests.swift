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
    let oid1 = try ASN1ObjectIdentifier(oid: "1.2.840.10045.3.1.7")
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
  
  func testBitStringEquality() throws {
    let bitstringData: [UInt8] = [0x47, 0xeb, 0x99, 0x5a, 0xdf, 0x9e, 0x70, 0x0d, 0xfb, 0xa7, 0x31, 0x32, 0xc1, 0x5f]
    let referenceBitstring1 = try DERParser.parse(der: Data([DERParser.Tag.bitString.rawValue, 0x0F, 0x00] + bitstringData))
    let referenceBitstring2 = try DERParser.parse(der: Data([DERParser.Tag.bitString.rawValue, 0x0F, 0x03] + bitstringData))

    XCTAssert(referenceBitstring1 is ASN1BitString)
    XCTAssert(referenceBitstring2 is ASN1BitString)
    if let referenceBitstring1 = referenceBitstring1 as? ASN1BitString, let referenceBitstring2 = referenceBitstring2 as? ASN1BitString {
      let bs1 = ASN1BitString(value: bitstringData, paddingLength: 0)
      let bs2 = ASN1BitString(value: referenceBitstring1.bytes, paddingLength: referenceBitstring1.paddingLength)
      let bs3 = ASN1BitString(value: [0x00] + bitstringData, paddingLength: 8)
      let bs4 = ASN1BitString(value: [0x00, 0x00, 0x00] + bitstringData, paddingLength: 3 * 8)
      XCTAssertEqual(bs1, referenceBitstring1)
      XCTAssertEqual(bs2, referenceBitstring1)
      XCTAssertEqual(bs3, referenceBitstring1)
      XCTAssertEqual(bs4, referenceBitstring1)
      
      let bs5 = ASN1BitString(value: referenceBitstring2.bytes, paddingLength: referenceBitstring2.paddingLength)
      let bs6 = ASN1BitString(value: [0x00] + referenceBitstring2.bytes, paddingLength: 8 + referenceBitstring2.paddingLength)
      XCTAssertEqual(bs5, referenceBitstring2)
      XCTAssertEqual(bs6, referenceBitstring2)
      
      XCTAssertNotEqual(bs1, bs5)
      XCTAssertNotEqual(bs1, bs6)
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
