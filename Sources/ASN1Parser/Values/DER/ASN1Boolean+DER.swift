//
//  ASN1Boolean+DER.swift
//  
//
//  Created by Dominik Horn on 14.11.21.
//

import Foundation

extension ASN1Boolean: DERDecodable {
  /// https://docs.microsoft.com/en-us/windows/win32/seccertenroll/about-boolean
  init(der: Data) throws {
    guard der.count == 1 else {
      throw ASN1DERParsingError.invalidTLVLength
    }
    
    let byte = try der.tryAccess(at: der.startIndex)
    guard byte == 0x00 || byte == 0x01 else {
      throw ASN1ValueParsingError.invalidBoolean
    }
    
    value = byte != 0
  }
}
