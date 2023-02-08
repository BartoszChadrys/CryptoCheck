//
//  CoinManager.swift
//  CryptoCheck
//
//  Created by Bartek Chadryś on 07/02/2023.
//

import Foundation
import UIKit

protocol CoinManagerDelegate {
    func didFailWithError(error: Error)
    func updateCurrency(coinManager: CoinManager, coinJson: CoinJson)
}

struct CoinManager {
    
    var selectedCrypto : String = "BTC"
    var selectedCurrency : String = "AUD"
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate"
    let apiKey = "3D16085D-206D-4ECE-A43C-42B0674588E6"
    let currencyArray = ["AUD","BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let cryptoArray = ["BTC","ETH","USDT","BNB","USDC","XRP","BUSD","ADA","DOGE","SOL","MATIC","DOT"]

    var delegate : CoinManagerDelegate?
    
    func createUrl(_ currency: String, _ cryptoCurrency: String) -> String {
        return "\(baseURL)/\(cryptoCurrency)/\(currency)?apikey=\(apiKey)"
    }
    
    func getCoinRate() {
        let urlString = createUrl(selectedCurrency, selectedCrypto)
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, reponse, error in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let parsedData = parseJSON(safeData) {
                        delegate?.updateCurrency(coinManager: self, coinJson: parsedData)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> CoinJson? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinJson.self, from: data)
            return decodedData
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
}
