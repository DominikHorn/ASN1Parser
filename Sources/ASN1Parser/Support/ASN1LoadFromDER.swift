//
//  File.swift
//  
//
//  Created by Dominik Horn on 13.11.21.
//

import Foundation

protocol ASN1LoadFromDER {
  init(der: Data) throws
}
