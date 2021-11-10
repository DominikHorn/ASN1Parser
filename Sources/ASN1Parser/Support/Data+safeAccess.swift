//
//  Data+safeAccess.swift
//  
//
//  Created by Dominik Horn on 10.11.21.
//

import Foundation

extension Data {
  func tryAccess(at offset: Index) throws -> UInt8 {
    guard startIndex <= offset && offset < endIndex else {
      throw DataError.outOfBoundsRead
    }
    
    return self[offset]
  }
  
  enum DataError: Error {
    case outOfBoundsRead
  }
}
