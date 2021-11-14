//
//  DERParser.swift
//
//
//  Created by Dominik Horn on 10.11.21.
//

import Foundation

/// Parser for reading DER encoded ASN.1 data
public struct DERParser {
  /**
   Parse DER encoded ASN.1 data into an ASN.1 value tree
   
   - Parameter der: binary data, that will be decoded in this order, e.g., starting at index der.startIndex an moving to der.endIndex
   
   - Throws ``ASN1ParsingError`` when parsing fails, e.g., due to invalid encoding
   */
  public static func parse(der: Data) throws -> ASN1Value {
    var offset = der.startIndex
    return try parseTLV(der, offset: &offset)
  }
  
//  // TODO(dominik): implement visitor pattern for ASN1 tree
//  // TODO(dominik): access syntax value.sequence[1].bitstring
//  public static func visit(_ value: ASN1Value, visitor: ASN1Visitor) {}
}
