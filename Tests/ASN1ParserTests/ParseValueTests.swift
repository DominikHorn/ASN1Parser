import XCTest
@testable import ASN1Parser

import BigInt

/// Parsing values from binary data
final class ParseValueTests: XCTestCase {
  func testSafelyParseGarbage() throws {
    // TODO(dominik): add more garbage inputs
    XCTAssertThrowsError(try DERParser.parse(der: Data([])))
    XCTAssertThrowsError(try DERParser.parse(der: Data([0x00])))
    XCTAssertThrowsError(try DERParser.parse(der: Data([0x00,0x01, 0x00])))
    XCTAssertThrowsError(try DERParser.parse(der: Data([0x02,0x00])))
  }
  
  func testParseLength() throws {
    XCTAssertNoThrow(try DERParser.parse(der: Data([DERParser.Tag.integer.rawValue, 0x01, 0xFF])))
    XCTAssertNoThrow(try DERParser.parse(der: Data([DERParser.Tag.integer.rawValue, 0x03, 0x00, 0xFF, 0xFF])))
    
    // cases that should fail
    XCTAssertThrowsError(try DERParser.parse(der: Data([DERParser.Tag.integer.rawValue, 0x00, 0x02])))
    XCTAssertThrowsError(try DERParser.parse(der: Data([DERParser.Tag.integer.rawValue, 0x02, 0x02])))
    XCTAssertThrowsError(try DERParser.parse(der: Data([DERParser.Tag.integer.rawValue, 0x03, 0x02])))
    XCTAssertThrowsError(try DERParser.parse(der: Data([DERParser.Tag.integer.rawValue, 0x01])))
  }
  
  func testParseBoolean() throws {
    // false alue
    var val: ASN1Value = try DERParser.parse(der: Data([DERParser.Tag.boolean.rawValue, 0x01, 0x00]))
    XCTAssert(val is ASN1Boolean)
    if let bool = val as? ASN1Boolean {
      XCTAssertEqual(bool.swiftValue, false)
    }
    
    // true value
    val = try DERParser.parse(der: Data([DERParser.Tag.boolean.rawValue, 0x01, 0x01]))
    XCTAssert(val is ASN1Boolean)
    if let bool = val as? ASN1Boolean {
      XCTAssertEqual(bool.swiftValue, true)
    }
    
    // failed parsing wrong bool values
    XCTAssertThrowsError(try DERParser.parse(der: Data([DERParser.Tag.boolean.rawValue, 0x01, 0x02])))
    XCTAssertThrowsError(try DERParser.parse(der: Data([DERParser.Tag.boolean.rawValue, 0x01, 0x05])))
    XCTAssertThrowsError(try DERParser.parse(der: Data([DERParser.Tag.boolean.rawValue, 0x01, 0x10])))
    XCTAssertThrowsError(try DERParser.parse(der: Data([DERParser.Tag.boolean.rawValue, 0x01, 0xFE])))
    XCTAssertThrowsError(try DERParser.parse(der: Data([DERParser.Tag.boolean.rawValue, 0x01, 0xFF])))
    XCTAssertThrowsError(try DERParser.parse(der: Data([DERParser.Tag.boolean.rawValue, 0x03, 0x00, 0x01, 0x00])))
  }
  
  func testParseInteger() throws {
    var val: ASN1Value = try DERParser.parse(der: Data([DERParser.Tag.integer.rawValue, 0x01, 0x03]))
    XCTAssert(val is ASN1Integer)
    if let int = val as? ASN1Integer {
      XCTAssertEqual(int.swiftValue, 3)
    }

    val = try DERParser.parse(der: Data([DERParser.Tag.integer.rawValue, 0x01, 0x85]))
    XCTAssert(val is ASN1Integer)
    if let int = val as? ASN1Integer {
      XCTAssertEqual(int.swiftValue, -5)
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
    val = try DERParser.parse(der: Data([
      DERParser.Tag.integer.rawValue, 0x81, 0x81, 0x00
    ] + longUIntData))
    XCTAssert(val is ASN1Integer)
    if let int = val as? ASN1Integer {
      let referenceVal = BigInt(sign: .plus, magnitude: BigUInt(Data(longUIntData)))
      XCTAssertEqual(referenceVal, int.swiftValue)
    }
  }
  
  func testParseNull() throws {
    let val: ASN1Value  = try DERParser.parse(der: Data([DERParser.Tag.null.rawValue, 0x00]))
    XCTAssert(val is ASN1Null)
    
    // failed parsing wrong bool values
    XCTAssertThrowsError(try DERParser.parse(der: Data([DERParser.Tag.null.rawValue, 0x01, 0x00])))
  }
  
  func testParseObjectIdentifier() throws {
    var val: ASN1Value = try DERParser.parse(der: Data([DERParser.Tag.objectIdentifier.rawValue, 0x07, 0x2A, 0x86, 0x48, 0xCE, 0x3D, 0x02, 0x01]))
    XCTAssert(val is ASN1ObjectIdentifier)
    if let objectID = val as? ASN1ObjectIdentifier {
      XCTAssertEqual(objectID.id, "1.2.840.10045.2.1")
    }
    
    val = try DERParser.parse(der: Data([DERParser.Tag.objectIdentifier.rawValue, 0x08, 0x2A, 0x86, 0x48, 0xCE, 0x3D, 0x03, 0x01, 0x07]))
    XCTAssert(val is ASN1ObjectIdentifier)
    if let objectID = val as? ASN1ObjectIdentifier {
      XCTAssertEqual(objectID.id, "1.2.840.10045.3.1.7")
    }
    
    val = try DERParser.parse(der: Data([DERParser.Tag.objectIdentifier.rawValue, 0x09, 0x2b, 0x06, 0x01, 0x04, 0x01, 0x82, 0x37, 0x15, 0x14]))
    XCTAssert(val is ASN1ObjectIdentifier)
    if let objectID = val as? ASN1ObjectIdentifier {
      XCTAssertEqual(objectID.id, "1.3.6.1.4.1.311.21.20")
    }
    
    
    // empty input
    XCTAssertThrowsError(try DERParser.parse(der: Data([DERParser.Tag.objectIdentifier.rawValue, 0x00])))
    // a leading bit states that there is more bytes when there is not
    XCTAssertThrowsError(try DERParser.parse(der: Data([DERParser.Tag.objectIdentifier.rawValue, 0x09, 0x2b, 0x06, 0x01, 0x04, 0x01, 0x82, 0x37, 0x15, 0x94])))
  }
  
  func testParseBitString() throws {
    let bitstringData: [UInt8] = [0x47, 0xeb, 0x99, 0x5a, 0xdf, 0x9e, 0x70, 0x0d, 0xfb, 0xa7, 0x31, 0x32, 0xc1, 0x5f]
    let bitstringString = "0100011111101011100110010101101011011111100111100111000000001101111110111010011100110001001100101100000101011111"
    
    var val: ASN1Value = try DERParser.parse(der: Data([DERParser.Tag.bitString.rawValue, 0x0F, 0x00] + bitstringData))
    XCTAssert(val is ASN1BitString)
    if let bitstring = val as? ASN1BitString {
      XCTAssertEqual(bitstring.count, bitstringString.count)
      XCTAssertEqual(bitstring.bytes, bitstringData)
      XCTAssertEqual(bitstring.string, bitstringString)
      
      bitstringString.enumerated().forEach { i, char in
        XCTAssertEqual(Bool(char == "1"), bitstring[i])
      }
    }
    
    let shortenedBitstringString = String(bitstringString.dropLast(3))
    val = try DERParser.parse(der: Data([DERParser.Tag.bitString.rawValue, 0x0F, 0x03] + bitstringData))
    XCTAssert(val is ASN1BitString)
    if let bitstring = val as? ASN1BitString {
      XCTAssertEqual(bitstring.count, shortenedBitstringString.count)
      XCTAssertEqual(bitstring.string, shortenedBitstringString)
      
      shortenedBitstringString.enumerated().forEach { i, char in
        XCTAssertEqual(Bool(char == "1"), bitstring[i])
      }
    }
    
    // empty input
    XCTAssertThrowsError(try DERParser.parse(der: Data([DERParser.Tag.bitString.rawValue, 0x00])))
    // wrong last unused field
    XCTAssertThrowsError(try DERParser.parse(der: Data([DERParser.Tag.bitString.rawValue, 0x03, 0x09, 0xAF, 0xFA])))
    // missing bitstring data
    XCTAssertThrowsError(try DERParser.parse(der: Data([DERParser.Tag.bitString.rawValue, 0x01, 0x03])))
  }
  
  func testParseOctetString() throws {
    let data: [UInt8] = [0x47, 0xeb, 0x99, 0x5a, 0xdf, 0x9e, 0x70, 0x0d, 0xfb, 0xa7, 0x31, 0x32, 0xc1, 0x5f]
    
    let val: ASN1Value = try DERParser.parse(der: Data([DERParser.Tag.octetString.rawValue, 0x0E] + data))
    XCTAssert(val is ASN1OctetString)
    if let octetstring = val as? ASN1OctetString {
      XCTAssertEqual(octetstring.count, data.count)
      XCTAssertEqual(octetstring.bytes, data)
    }
  }
  
  func testParseUTF8String() throws {
    let data: [UInt8] = [
      0x76, 0x69, 0x63, 0x68, 0x33, 0x64, 0x2e, 0x6a,
      0x64, 0x6f, 0x6d, 0x63, 0x73, 0x63, 0x2e, 0x6e
    ]
    
    var val: ASN1Value = try DERParser.parse(der: Data([DERParser.Tag.utf8String.rawValue, 0x10] + data))
    XCTAssert(val is ASN1UTF8String)
    if let string = val as? ASN1UTF8String {
      XCTAssertEqual(string.value, "vich3d.jdomcsc.n")
    }
    
    val = try DERParser.parse(der: Data([DERParser.Tag.utf8String.rawValue, 0x00]))
    XCTAssert(val is ASN1UTF8String)
    if let string = val as? ASN1UTF8String {
      XCTAssertEqual(string.value, "")
    }
  }
  
  func testParseSequence() throws {
    // single element in sequence
    let val = try DERParser.parse(der: Data([
      DERParser.Tag.sequence.rawValue, 0x03,
        DERParser.Tag.boolean.rawValue, 0x01, 0x01
    ]))
    XCTAssert(val is ASN1Sequence)
    if let sequence = val as? ASN1Sequence {
      XCTAssertEqual(sequence.values.count, 1)
      XCTAssert(sequence.values.first is ASN1Boolean)
      if let bool = sequence.values.first as? ASN1Boolean {
        XCTAssertEqual(bool.swiftValue, true)
      }
    }
    
    // multiple elements in sequence
    let val2 = try DERParser.parse(der: Data([
      DERParser.Tag.sequence.rawValue, 0x09,
        DERParser.Tag.boolean.rawValue, 0x01, 0x00,
        DERParser.Tag.boolean.rawValue, 0x01, 0x01,
        DERParser.Tag.boolean.rawValue, 0x01, 0x00
    ]))
    XCTAssert(val2 is ASN1Sequence)
    if let sequence = val2 as? ASN1Sequence {
      XCTAssertEqual(sequence.values.count, 3)
      sequence.values.enumerated().forEach { i, bool in
        XCTAssert(bool is ASN1Boolean)
        if let bool = bool as? ASN1Boolean {
          switch i {
          case 0:
            XCTAssertEqual(bool.swiftValue, false)
          case 1:
            XCTAssertEqual(bool.swiftValue, true)
          case 2:
            XCTAssertEqual(bool.swiftValue, false)
          default:
            XCTFail()
          }
        }
      }
    }
    
    // failed parsing - empty sequence
    XCTAssertThrowsError(try DERParser.parse(der: Data([DERParser.Tag.sequence.rawValue, 0x00])))
  }
}
