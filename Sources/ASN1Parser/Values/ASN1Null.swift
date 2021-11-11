//
//  ASN1Null.swift
//  
//
//  Created by Dominik Horn on 11.11.21.
//

import Foundation

struct ASN1Null: ASN1Value {
  init() {}
  
  init(data: Data) throws {
    guard data.isEmpty else {
      throw ASN1ParsingError.invalidNull
    }
  }
}

extension ASN1Null: Equatable {}
