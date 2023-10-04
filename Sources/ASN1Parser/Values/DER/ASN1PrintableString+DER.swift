//
//  ASN1PrintableString+DER.swift
//  
//
//  Created by Matthias Scheurer on 29.09.23.
//

import Foundation

extension ASN1PrintableString: DERDecodable {
  /// https://docs.microsoft.com/en-us/windows/win32/seccertenroll/about-utf8string
  init(der: Data) throws {
      self.value = .init(decoding: der, as: UTF8.self)
  }
}
