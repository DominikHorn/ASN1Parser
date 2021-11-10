//
//  ASN1Parser.swift
//
//
//  Created by Dominik Horn on 10.11.21.
//

import Foundation

public struct ASN1Parser {
  public static func parse(_ data: Data) throws -> ASN1Value {
    var offset = data.startIndex
    return try parseTLV(data, offset: &offset)
  }
  
//  // TODO(dominik): implement visitor pattern for ASN1 tree
//  public static func visit(_ value: ASN1Value, visitor: ASN1Visitor) {}
}
