//
//  ASN1Sequence+DER.swift
//  
//
//  Created by Dominik Horn on 14.11.21.
//

import Foundation

extension ASN1Sequence: DERDecodable {
  /// https://docs.microsoft.com/en-us/windows/win32/seccertenroll/about-sequence
  init(der: Data) throws {
    var offset = der.startIndex
    while offset < der.endIndex {
      values.append(try DERParser.parseTLV(der, offset: &offset))
    }
    
    guard !values.isEmpty else {
      throw ASN1ParsingError.invalidSequence
    }
  }
}
