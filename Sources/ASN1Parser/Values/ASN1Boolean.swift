//
//  ASN1Boolean.swift
//  
//
//  Created by Dominik Horn on 10.11.21.
//

import Foundation

struct ASN1Boolean: ASN1Value {
  var value: Bool
  
  init(data: Data) throws {
    guard data.count == 1 else {
      throw ASN1ParsingError.invalidLength
    }
    
    let byte = try data.tryAccess(at: data.startIndex)
    guard byte == 0x00 || byte == 0x01 else {
      throw ASN1ParsingError.derViolation
    }
    
    value = byte != 0
  }
}
