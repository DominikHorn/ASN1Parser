//
//  DERParser.swift
//
//
//  Created by Dominik Horn on 10.11.21.
//

import Foundation

public struct DERParser {
  public static func parse(der: Data) throws -> ASN1Value {
    var offset = der.startIndex
    return try parseTLV(der, offset: &offset)
  }
  
//  // TODO(dominik): implement visitor pattern for ASN1 tree
//  // TODO(dominik): access syntax value.sequence[1].bitstring
//  public static func visit(_ value: ASN1Value, visitor: ASN1Visitor) {}
}
