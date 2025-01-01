//
//  CoinDetailDataService.swift
//  CryptoApp
//
//  Created by Dmitriy Eliseev on 27.12.2024.
//

import Foundation
import Combine

final class CoinDetailDataService {
    
    @Published var coinDetails: СoinDetailModel? = nil
    private var cancellables: AnyCancellable?
    private let coin: CoinModel // нужна для кастомизации запроса к API по id валюты
    
    init(coin: CoinModel){
        self.coin = coin
        getDetailCoins()
    }
    
    func getDetailCoins(){
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else
        { return }
        cancellables = NetworkingManager.download(url: url) //Оптимизация кода
            .decode(type: СoinDetailModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main) //переходим в main поток тут, (refactor NetworkingManager)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedCoinDetais) in
                guard let self = self else { return }
                self.coinDetails = returnedCoinDetais
                print(returnedCoinDetais)
                self.cancellables?.cancel()
            })
    }
    
}
