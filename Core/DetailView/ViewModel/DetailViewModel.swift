//
//  DetailViewModel.swift
//  CryptoApp
//
//  Created by Dmitriy Eliseev on 27.12.2024.
//

import Foundation
import Combine

final class DetailViewModel: ObservableObject {
   
    private let coinDetailService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coinDetailService = CoinDetailDataService(coin: coin)
    }
    
    private func addSubscribers() {
        coinDetailService.$coinDetails
            .sink { [weak self] (returnedCoinDetails) in
                print("RECIEVED COIN DETAIL DATA")
                print(returnedCoinDetails)
              
            }
            .store(in: &cancellables)
    }
}

