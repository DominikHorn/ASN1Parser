//
//  ASN1OctetString+DER.swift
//  
//
//  Created by Dominik Horn on 16.11.21.
//

import Foundation

extension ASN1OctetString: DERDecodable {
  /// https://docs.microsoft.com/en-us/windows/win32/seccertenroll/about-octet-string
  init(der: Data) throws {
    self.bytes = .init(der)
  }
}
