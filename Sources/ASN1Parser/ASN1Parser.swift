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
}
