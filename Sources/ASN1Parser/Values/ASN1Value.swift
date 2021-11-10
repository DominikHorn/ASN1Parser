//
//  ASN1Value.swift
//  
//
//  Created by Dominik Horn on 10.11.21.
//

import Foundation

public protocol ASN1Value {
  init(data: Data) throws
}
