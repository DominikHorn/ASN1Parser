//
//  ASN1Boolean.swift
//  
//
//  Created by Dominik Horn on 10.11.21.
//

import Foundation

struct ASN1Boolean: ASN1Value {
  var swiftValue: Bool
  
  init(_ swiftValue: Bool) {
    self.swiftValue = swiftValue
  }
  
  init(data: Data) throws {
    guard data.count == 1 else {
      throw ASN1ParsingError.invalidTLVLength
    }
    
    let byte = try data.tryAccess(at: data.startIndex)
    guard byte == 0x00 || byte == 0x01 else {
      throw ASN1ParsingError.derViolation
    }
    
    swiftValue = byte != 0
  }
}

extension ASN1Boolean: Equatable {}
