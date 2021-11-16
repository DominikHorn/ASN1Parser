//
//  ASN1UTF8String.swift
//  
//
//  Created by Dominik Horn on 16.11.21.
//

import Foundation

extension ASN1UTF8String: DERDecodable {
  /// https://docs.microsoft.com/en-us/windows/win32/seccertenroll/about-utf8string
  init(der: Data) throws {
    self.value = .init(decoding: der, as: UTF8.self)
  }
}
