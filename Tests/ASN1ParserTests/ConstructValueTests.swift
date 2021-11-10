import XCTest
@testable import ASN1Parser

/// Constructing values programatically
final class ConstructValueTests: XCTestCase {
  func testConstructBoolean() {
    let bool = ASN1Boolean(true)
    XCTAssert(true == bool.swiftValue)
    
    let bool2 = ASN1Boolean(false)
    XCTAssert(false == bool2.swiftValue)
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
