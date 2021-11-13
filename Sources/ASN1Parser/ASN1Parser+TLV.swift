//
//  ASN1Parser+TLV.swift
//  
//
//  Created by Dominik Horn on 10.11.21.
//

import Foundation
import BigInt

extension ASN1Parser {
  /// As documented in https://docs.microsoft.com/en-us/windows/win32/seccertenroll/about-encoded-length-and-value-bytes
  struct Length: ASN1Decodable {
    var value: Int
    
    init(_ data: Data, offset: inout Data.Index) throws {
      let firstByte = try data.tryAccess(at: offset)
      offset += 1
      
      value = Int(firstByte)
      
      if firstByte.bit(at: 7) {
        let trailingByteCount = Int(firstByte & ((0x1 << 7) - 1))
        
        guard trailingByteCount < MemoryLayout<Int>.size else {
          throw ASN1ParsingError.unsupportedTLVLength
        }

        let dataView = data[offset..<(offset+trailingByteCount)]
        offset += trailingByteCount
        (dataView as NSData).getBytes(&value, length: MemoryLayout<Int>.size)
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
      let firstByte = try data.tryAccess(at: offset)
      guard let tag = Tag(rawValue: firstByte) else {
        throw ASN1ParsingError.unreadableTag(firstByte)
      }
      self = tag
      offset += 1
    }
  }
  
  internal static func parseTLV(_ data: Data, offset: inout Data.Index) throws -> ASN1Value {
    let tag = try Tag(data, offset: &offset)
    let length = try Length(data, offset: &offset)
    
    // special case: null value
    if case tag = Tag.null {
      guard length.value == 0 else {
        throw ASN1ParsingError.invalidNull
      }
      return ASN1Null()
    }
    
    // perform bounds check before access
    guard length.value > 0, length.value <= data.endIndex - offset else {
      throw ASN1ParsingError.invalidTLVLength
    }
    
    // each tag identifies a specific ASN1Value
    var value: ASN1Value
    let dataView = data[offset..<(offset+length.value)]
    
    switch tag {
    case .boolean:
      value = try ASN1Boolean(data: dataView)
    case .integer:
      value = try ASN1Integer(data: dataView)
    case .objectIdentifier:
      value = try ASN1ObjectIdentifier(data: dataView)
    case .sequence:
      value = try ASN1Sequence(data: dataView)
    default:
      throw ASN1ParsingError.unimplemented(tag: tag, length: length, value: dataView)
    }
    
    offset += length.value
    return value
  }
}
