//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate"
    let asset = "BTC"
    let apiKey = "53239663-AD99-48FF-B2FE-656F340A1545"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String) {
        // URL string
        let urlString = "\(baseURL)/\(asset)/\(currency)?apikey=\(apiKey)"
        // Optional binding to unwrap into URL object
        if let url = URL(string: urlString) {
            // Create URLSession object
            let session = URLSession(configuration: .default)
            // Create data task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData) {
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                    }
                }
            }
            // Start task to fetch data from bitcoin average's servers.
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double? {
        // Create JSONDecoder
        let decoder = JSONDecoder()
        do {
            // Attempt to decode data using CoinData structure
            let decodedData = try decoder.decode(CoinData.self, from: data)
            // Get last property from decoded data
            let lastPrice = decodedData.rate
            print(lastPrice)
            return lastPrice
        } catch {
            // Print any errors
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
