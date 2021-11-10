//
//  ASN1TLV.swift
//  
//
//  Created by Dominik Horn on 10.11.21.
//

import Foundation

struct ASN1TLV: ASN1Value {
  var tag: Tag
  var length: Length
  var value: ASN1Value
  
  init(_ data: Data, offset: inout Data.Index) throws {
    self.tag = try Tag(data, offset: &offset)
    self.length = try Length(data, offset: &offset)
    
    // each tag identifies a specific ASN1Value
    switch tag {
    default:
      throw ASN1ParsingError.unimplemented(tag)
    }
  }
}
