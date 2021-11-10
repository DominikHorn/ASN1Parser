//
//  ASN1TLV+Tag.swift
//  
//
//  Created by Dominik Horn on 10.11.21.
//

import Foundation

/// As documented in https://docs.microsoft.com/en-us/windows/win32/seccertenroll/about-encoded-tag-bytes
extension ASN1TLV {
  enum Tag: UInt8, ASN1Value {
    case boolean = 0x01
    case integer = 0x02
    case bitString = 0x03
    case octetString = 0x04
    case null = 0x05
    case objectIdentifier = 0x06
    case utf8String = 0x0C
    case printableString = 0x13
    case teletexString = 0x14
    case ia5String = 0x16
    case sequence = 0x30
    case set = 0x31
    case bmpString = 0x1E
    
    init(_ data: Data, offset: inout Data.Index) throws {
      guard let tag = Tag(rawValue: data[offset]) else {
        throw ASN1ParsingError.invalidTag
      }
      self = tag
      offset += 1
    }
  }
}
