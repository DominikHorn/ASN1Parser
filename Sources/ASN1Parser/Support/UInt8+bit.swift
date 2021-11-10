//
//  UInt8+bit.swift
//  
//
//  Created by Dominik Horn on 10.11.21.
//

import Foundation

extension UInt8 {
  func bit(at: Int) -> Bool {
    precondition(at >= 0)
    precondition(at < 8)
    
    return (self & (0x1 << at)) != 0
  }
}
