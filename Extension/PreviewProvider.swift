//
//  PreviewProvider.swift
//  CryptoApp
//
//  Created by Dmitriy Eliseev on 20.12.2024.
//

import Foundation
import SwiftUI

extension PreviewProvider {
    static var dev: DeveloperProvider {
        return DeveloperProvider.instance
    }
}


final class DeveloperProvider {
    static let instance = DeveloperProvider()
    private init(){ }
    
    let homeVM = HomeViewModel()
    
    let windowSize = CGSize(width: 393, height: 759) // чтение размера экрана iphone16
    
    let coin = CoinModel(
        id: "bitcoin",
        symbol: "btc",
        name: "Bitcoin",
        image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1696501400",
        currentPrice: 70187,
        marketCap: 1381651251183,
        marketCapRank: 1,
        fullyDilutedValuation: 1474623675796,
        totalVolume: 20154184933,
        high24H: 70215,
        low24H: 68060,
        priceChange24H: 2126.88,
        priceChangePercentage24H: 3.12502,
        marketCapChange24H: 44287678051,
        marketCapChangePercentage24H: 3.31157,
        circulatingSupply: 19675987,
        totalSupply: 21000000,
        maxSupply: 21000000,
        ath: 73738,
        athChangePercentage: -4.77063,
        athDate: "2024-03-14T07:10:36.635Z",
        atl: 67.81,
        atlChangePercentage: 103455.83335,
        atlDate: "2013-07-06T00:00:00.000Z",
        lastUpdated: "2024-04-07T16:49:31.736Z",
        sparklineIn7D:   SparklineIn7D(price: [101744.02466948032, 102392.35475315936]),
        priceChangePercentage24HInCurrency: -4.298996003078433,
        currentHoldings: 1
    )
    
    let stat: [StatisticModel] = [
        StatisticModel(title: "Title", value: "Value", percentageChange: 1),
        StatisticModel(title: "Title", value: "Value"),
        StatisticModel(title: "Title", value: "Value", percentageChange: -7)
    ]
    
}
