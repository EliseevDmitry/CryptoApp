//
//  MarketDataService.swift
//  CryptoApp
//
//  Created by Dmitriy Eliseev on 23.12.2024.
//

import Foundation
import Combine

final class MarketDataService {
  
    @Published var marketData: MarketDataModel? = nil
    var marketDataSubscription: AnyCancellable?
    
    init(){
        getCoins()
    }
    
    
    private func getCoins(){
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else
        { return }
        marketDataSubscription = NetworkingManager.download(url: url) //Оптимизация кода
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedGlobalData) in
                guard let self = self else { return }
                self.marketData = returnedGlobalData.data
                self.marketDataSubscription?.cancel()
            }) 
    }
}
