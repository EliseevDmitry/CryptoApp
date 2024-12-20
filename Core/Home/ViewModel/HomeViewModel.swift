//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Dmitriy Eliseev on 20.12.2024.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    
    private let dataService = CoinDataService()
    private var cancellable = Set<AnyCancellable>()
    
    init(){
        /*
        //имитация загрузки данных из сети
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){ [weak self] in
            self?.allCoins.append(DeveloperProvider.instance.coin)
            self?.portfolioCoins.append(DeveloperProvider.instance.coin)
        }
         */
        addSubscribers()
    }
    
    func addSubscribers(){
        dataService.$allCoins
            .sink {[weak self] (returnedCoins) in
                guard let self = self else { return }
                self.allCoins = returnedCoins
            }
            .store(in: &cancellable)
    }
}
