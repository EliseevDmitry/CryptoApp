//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Dmitriy Eliseev on 20.12.2024.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var statistics: [StatisticModel] = [
        StatisticModel(title: "Title", value: "Value", percentageChange: 1),
        StatisticModel(title: "Title", value: "Value"),
        StatisticModel(title: "Title", value: "Value", percentageChange: -7),
        StatisticModel(title: "Title", value: "Value", percentageChange: -74.9)
    ]
    
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText: String = ""
    
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
        /*
         Так как @Published - это паблюшер, а для фильтрации - требуется объединить получение данных "всех монет" и текстовое поле "поиска" - текущая реализация не актуальна
         
         dataService.$allCoins
         .sink {[weak self] (returnedCoins) in
         guard let self = self else { return }
         self.allCoins = returnedCoins
         }
         .store(in: &cancellable)
         */
        
        $searchText
            .combineLatest(dataService.$allCoins) //добавляет еще одного паблюшера
        //задержка для того чтобы при вводе символов с клавиатуры - каждый раз не срабатывала функция фильтрации а только после паузы после 0.5 секунд
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins) //можно сократить до имени функции - в силу того, что параметры мы продублировали из автозаполнения .map - а потом вынесли в отдельную функцию
            .sink { [weak self] (returnedCoin) in
                if let self = self {
                    self.allCoins = returnedCoin
                }
            }
            .store(in: &cancellable)
    }
    
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else {
            return coins
        }
        let lowercastedText =  text.lowercased()
        return coins.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowercastedText) ||
            coin.symbol.lowercased().contains(lowercastedText) ||
            coin.id.lowercased().contains(lowercastedText)
        }
    }
}
