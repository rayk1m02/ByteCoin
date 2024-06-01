//
//  CoinData.swift
//  ByteCoin
//
//  Created by Raymond Kim on 2/12/24.
//  Copyright © 2024 The App Brewery. All rights reserved.
//

import Foundation

// Make the struct conform to the Decodable protocol to use it decode JSON
struct CoinData: Decodable {
    let rate: Double
}
