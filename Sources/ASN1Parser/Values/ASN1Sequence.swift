//
//  File.swift
//  
//
//  Created by Dominik Horn on 10.11.21.
//

import Foundation

struct ASN1Sequence: ASN1Value {
  var values = [ASN1Value]()
  
  init(data: Data) throws {
    var offset = data.startIndex
    while offset < data.endIndex {
      values.append(try ASN1Parser.parseTLV(data, offset: &offset))
    }
    
    guard values.count > 0 else {
      throw ASN1ParsingError.invalidSequence
    }
  }
}
