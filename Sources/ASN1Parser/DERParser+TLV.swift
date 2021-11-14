//
//  DERParser+TLV.swift
//  
//
//  Created by Dominik Horn on 10.11.21.
//

import Foundation
import BigInt

extension DERParser {
  /// As documented in https://docs.microsoft.com/en-us/windows/win32/seccertenroll/about-encoded-length-and-value-bytes
  struct Length {
    var value: Int
    
    init(_ der: Data, offset: inout Data.Index) throws {
      let firstByte = try der.tryAccess(at: offset)
      offset += 1
      
      value = Int(firstByte)
      
      if firstByte.bit(at: 7) {
        let trailingByteCount = Int(firstByte & ((0x1 << 7) - 1))
        
        guard trailingByteCount < MemoryLayout<Int>.size else {
          throw ASN1ParsingError.unsupportedTLVLength
        }

        let dataView = der[offset..<(offset+trailingByteCount)]
        offset += trailingByteCount
        (dataView as NSData).getBytes(&value, length: MemoryLayout<Int>.size)
      }
    }
  }
  /// As documented in https://docs.microsoft.com/en-us/windows/win32/seccertenroll/about-encoded-tag-bytes
  enum Tag: UInt8 {
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
    
    init(_ der: Data, offset: inout Data.Index) throws {
      let firstByte = try der.tryAccess(at: offset)
      guard let tag = Tag(rawValue: firstByte) else {
        throw ASN1ParsingError.unreadableTag(firstByte)
      }
      self = tag
      offset += 1
    }
  }
  
  internal static func parseTLV(_ der: Data, offset: inout Data.Index) throws -> ASN1Value {
    let tag = try Tag(der, offset: &offset)
    let length = try Length(der, offset: &offset)
    
    // perform bounds check before access
    guard length.value <= der.endIndex - offset else {
      throw ASN1ParsingError.invalidTLVLength
    }
    
    // each tag identifies a specific ASN1Value
    var value: ASN1Value
    let derView = length.value > 0 ? der[offset..<(offset+length.value)] : .init()
    
    switch tag {
    case .null:
      value = try ASN1Null(der: derView)
    case .boolean:
      value = try ASN1Boolean(der: derView)
    case .integer:
      value = try ASN1Integer(der: derView)
    case .objectIdentifier:
      value = try ASN1ObjectIdentifier(der: derView)
    case .bitString:
      value = try ASN1BitString(der: derView)
    case .sequence:
      value = try ASN1Sequence(der: derView)
    default:
      throw ASN1UnimplementedError(tag: tag, length: length, value: derView)
    }
    
    offset += length.value
    return value
  }
  
  struct ASN1UnimplementedError: Error {
    var tag: DERParser.Tag
    var length: DERParser.Length
    var value: Data
  }
}
