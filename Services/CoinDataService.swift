//
//  CoinDataService.swift
//  CryptoApp
//
//  Created by Dmitriy Eliseev on 21.12.2024.
//

import Foundation
import Combine

final class CoinDataService {
    //мы создаем паблишера
    @Published var allCoins: [CoinModel] = []
    var cancellables: AnyCancellable?
    
    init(){
        getCoins()
    }
    
    
    private func getCoins(){
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h&locale=ru&precision=full") else
        { return }
        
        cancellables = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap { (output) -> Data in
                guard let response = output.response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300
                else {throw URLError(.badServerResponse) }
                return output.data
            }
            .receive(on: DispatchQueue.main)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink { completion in
                switch completion  {
                case .finished:
                    break
                case.failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] (returnedCoins) in
                guard let self = self else { return }
                self.allCoins = returnedCoins
                self.cancellables?.cancel() //завершаем паблешера по завершению получения данных
            }
        
        
        
        
    }
}
