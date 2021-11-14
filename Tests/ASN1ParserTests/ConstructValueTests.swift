import XCTest
@testable import ASN1Parser

import BigInt

/// Constructing values programatically
final class ConstructValueTests: XCTestCase {
  func testConstructBoolean() throws {
    let bool = ASN1Boolean(true)
    XCTAssertEqual(bool.swiftValue, true)
    
    let bool2 = ASN1Boolean(false)
    XCTAssertEqual(bool2.swiftValue, false)
  }
  
  func testConstructInteger() throws {
    let int = ASN1Integer(1337)
    XCTAssertEqual(int.swiftValue, 1337)
    
    let int2 = ASN1Integer(-50)
    XCTAssertEqual(int2.swiftValue, -50)
    
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
    XCTAssertEqual(int3.swiftValue, BigInt(longUIntData))
  }
  
  func testConstructNull() throws {
    XCTAssertNoThrow(try ASN1Null(der: Data([])))
    XCTAssertEqual(try ASN1Null(der: Data([])), ASN1Null())
    
    XCTAssertThrowsError(try ASN1Null(der: Data([0x00])))
    XCTAssertThrowsError(try ASN1Null(der: Data([0x01])))
    XCTAssertThrowsError(try ASN1Null(der: Data([0xfa, 0xaf])))
  }
  
  func testConstructObjectIdentifier() throws {
    XCTAssertNoThrow(try ASN1ObjectIdentifier(id: "0.2.840.10045.3.1.7"))
    XCTAssertNoThrow(try ASN1ObjectIdentifier(id: "1.2.840.10045.3.1.7"))
    XCTAssertNoThrow(try ASN1ObjectIdentifier(id: "2.2.840.10045.3.1.7"))
    XCTAssertNoThrow(try ASN1ObjectIdentifier(id: "3.2.840.10045.3.1.7"))
    XCTAssertNoThrow(try ASN1ObjectIdentifier(id: "3.39.840.10045.3.1.7"))
    XCTAssertNoThrow(try ASN1ObjectIdentifier(id: "3.0.840.10045.3.1.7"))
    XCTAssertNoThrow(try ASN1ObjectIdentifier(id: "3.15.840.10045.3.1.7"))
    XCTAssertThrowsError(try ASN1ObjectIdentifier(id: "4.2.840.10045.3.1.7"))
    XCTAssertThrowsError(try ASN1ObjectIdentifier(id: "42.2.840.10045.3.1.7"))
    XCTAssertThrowsError(try ASN1ObjectIdentifier(id: "128.2.840.10045.3.1.7"))
    XCTAssertThrowsError(try ASN1ObjectIdentifier(id: "3.40.840.10045.3.1.7"))
    XCTAssertThrowsError(try ASN1ObjectIdentifier(id: "3.200.840.10045.3.1.7"))
    
    XCTAssertNoThrow(try ASN1ObjectIdentifier(nodes: [0, 2, 840, 10045, 3, 1, 7]))
    XCTAssertNoThrow(try ASN1ObjectIdentifier(nodes: [1, 2, 840, 10045, 3, 1, 7]))
    XCTAssertNoThrow(try ASN1ObjectIdentifier(nodes: [2, 2, 840, 10045, 3, 1, 7]))
    XCTAssertNoThrow(try ASN1ObjectIdentifier(nodes: [3, 2, 840, 10045, 3, 1, 7]))
    XCTAssertNoThrow(try ASN1ObjectIdentifier(nodes: [1, 39, 840, 10045, 3, 1, 7]))
    XCTAssertNoThrow(try ASN1ObjectIdentifier(nodes: [1, 0, 840, 10045, 3, 1, 7]))
    XCTAssertNoThrow(try ASN1ObjectIdentifier(nodes: [1, 27, 840, 10045, 3, 1, 7]))
    XCTAssertThrowsError(try ASN1ObjectIdentifier(nodes: [4, 29, 840, 10045, 3, 1, 7]))
    XCTAssertThrowsError(try ASN1ObjectIdentifier(nodes: [68, 29, 840, 10045, 3, 1, 7]))
    XCTAssertThrowsError(try ASN1ObjectIdentifier(nodes: [130, 29, 840, 10045, 3, 1, 7]))
    XCTAssertThrowsError(try ASN1ObjectIdentifier(nodes: [130, 29, 840, 10045, 3, 1, 7]))
    XCTAssertThrowsError(try ASN1ObjectIdentifier(nodes: [1, 40, 840, 10045, 3, 1, 7]))
    XCTAssertThrowsError(try ASN1ObjectIdentifier(nodes: [1, 1000232, 840, 10045, 3, 1, 7]))
  }

  func testConstructBitString() throws {
    let bitstringData: [UInt8] = [0x47, 0xeb, 0x99, 0x5a, 0xdf, 0x9e, 0x70, 0x0d, 0xfb, 0xa7, 0x31, 0x32, 0xc1, 0x5f]
    XCTAssertEqual(ASN1BitString(value: bitstringData, paddingLength: 0).bytes, bitstringData)
    XCTAssertEqual(ASN1BitString(value: bitstringData, paddingLength: 0).paddingLength, 0)
    
    XCTAssertEqual(ASN1BitString(value: [0x00] + bitstringData, paddingLength: 8).bytes, bitstringData)
    XCTAssertEqual(ASN1BitString(value: [0x00] + bitstringData, paddingLength: 8).paddingLength, 0)
    
    XCTAssertEqual(ASN1BitString(value: [0x00, 0x00, 0x00] + bitstringData, paddingLength: 3 * 8).bytes, bitstringData)
    XCTAssertEqual(ASN1BitString(value: [0x00, 0x00, 0x00] + bitstringData, paddingLength: 3 * 8).paddingLength, 0)

    let paddedData: [UInt8] = [0x08, 0xFD, 0x73, 0x2B, 0x5B, 0xF3, 0xCE, 0x01, 0xBF, 0x74, 0xE6, 0x26, 0x58, 0x2B]
    XCTAssertEqual(ASN1BitString(value: paddedData, paddingLength: 3).bytes, paddedData)
    XCTAssertEqual(ASN1BitString(value: paddedData, paddingLength: 3).paddingLength, 3)
  }
  
  func testConstructSequence() throws {
    XCTAssertThrowsError(try ASN1Sequence([]))
    
    let seq = ASN1Sequence(ASN1Boolean(false))
    XCTAssertEqual(seq.values.count, 1)
    XCTAssert(seq.values.first is ASN1Boolean)
    if let bool = seq.values.first as? ASN1Boolean {
      XCTAssertEqual(bool.swiftValue, false)
    }
    
    let seq2 = try ASN1Sequence([ASN1Boolean(false)])
    XCTAssertEqual(seq, seq2)
    
    let seq3 = ASN1Sequence(ASN1Boolean(true), ASN1Boolean(false), ASN1Boolean(false))
    XCTAssertEqual(seq3.values.count, 3)
    seq3.values.forEach { val in
      XCTAssert(val is ASN1Boolean)
    }
    
    let  seq4 = try ASN1Sequence([ASN1Boolean(true), ASN1Boolean(false)])
    XCTAssertNotEqual(seq3, seq4)
    
    let seq5 = try ASN1Sequence([ASN1Boolean(true), ASN1Boolean(false), ASN1Boolean(false)])
    XCTAssertEqual(seq3, seq5)
  }
}
