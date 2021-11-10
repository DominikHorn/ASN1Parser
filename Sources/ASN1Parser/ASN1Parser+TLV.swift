//
//  ASN1Parser+TLV.swift
//  
//
//  Created by Dominik Horn on 10.11.21.
//

import Foundation

extension ASN1Parser {
  /// As documented in https://docs.microsoft.com/en-us/windows/win32/seccertenroll/about-encoded-length-and-value-bytes
  struct Length: ASN1Decodable {
    let value: Int
    
    init(_ data: Data, offset: inout Data.Index) throws {
      let firstByte = try data.tryAccess(at: offset)
      offset += 1
      
      if firstByte.bit(at: 7) {
        value = Int(firstByte & ((0x1 << 7) - 1))
      } else {
        value = Int(firstByte)
      }
    }
  }
  /// As documented in https://docs.microsoft.com/en-us/windows/win32/seccertenroll/about-encoded-tag-bytes
  enum Tag: UInt8, ASN1Decodable {
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
      guard let tag = Tag(rawValue: try data.tryAccess(at: offset)) else {
        throw ASN1ParsingError.unreadableTag
      }
      self = tag
      offset += 1
    }
  }
  
  internal static func parseTLV(_ data: Data, offset: inout Data.Index) throws -> ASN1Value {
    let tag = try Tag(data, offset: &offset)
    let length = try Length(data, offset: &offset)
    
    // TODO(dominik): does this have to be the case?
    guard length.value > 0 else {
      throw ASN1ParsingError.invalidTLVLength
    }
    
    // each tag identifies a specific ASN1Value
    var value: ASN1Value
    switch tag {
    case .boolean:
      value = try ASN1Boolean(data: data[offset..<(offset+length.value)])
    case .sequence:
      value = try ASN1Sequence(data: data[offset..<(offset+length.value)])
    default:
      throw ASN1ParsingError.unimplementedValue
    }
    
    offset += length.value
    return value
  }
}
