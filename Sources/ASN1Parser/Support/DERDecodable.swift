//
//  DERDecodable.swift
//  
//
//  Created by Dominik Horn on 13.11.21.
//

import Foundation

protocol DERDecodable {
  init(der: Data) throws
}
