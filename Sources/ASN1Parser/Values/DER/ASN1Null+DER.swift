//
//  ASN1Null+DER.swift
//  
//
//  Created by Dominik Horn on 14.11.21.
//

import Foundation

extension ASN1Null: DERDecodable {
  /// https://docs.microsoft.com/en-us/windows/win32/seccertenroll/about-null
  init(der: Data) throws {
    guard der.isEmpty else {
      throw ASN1ParsingError.invalidNull
    }
  }
}
