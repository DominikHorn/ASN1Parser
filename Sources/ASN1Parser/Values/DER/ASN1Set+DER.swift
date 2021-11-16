//
//  ASN1Set+DER.swift
//  
//
//  Created by Dominik Horn on 16.11.21.
//

import Foundation

extension ASN1Set: DERDecodable {
  /// https://docs.microsoft.com/en-us/windows/win32/seccertenroll/about-set
  init(der: Data) throws {
    var offset = der.startIndex
    
    var values = [ASN1Value]()
    while offset < der.endIndex {
      values.append(try DERParser.parseTLV(der, offset: &offset))
    }
    
    try self.init(values)
  }
}
