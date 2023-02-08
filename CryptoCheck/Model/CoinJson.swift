//
//  CoinData.swift
//  CryptoCheck
//
//  Created by Bartek Chadryś on 07/02/2023.
//

import Foundation

struct CoinJson : Decodable {
    let rate: Double
    let asset_id_quote: String
    let asset_id_base: String
}
