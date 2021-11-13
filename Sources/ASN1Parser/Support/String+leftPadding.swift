//
//  String+leftPadding.swift
//
//
//  Created by Dominik Horn on 13.11.21.
//

import Foundation

extension String {
  func leftPadding(toLength: Int, withPad character: Character) -> String {
    guard count < toLength else { return self }
    
    return String(repeatElement(character, count: toLength - count)) + self
  }
}

