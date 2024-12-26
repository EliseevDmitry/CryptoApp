//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Dmitriy Eliseev on 20.12.2024.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    /*
     заменяем моковые данные после добавления сервиcа - marketDataService = MarketDataService()
    @Published var statistics: [StatisticModel] = [
        StatisticModel(title: "Title", value: "Value", percentageChange: 1),
        StatisticModel(title: "Title", value: "Value"),
        StatisticModel(title: "Title", value: "Value", percentageChange: -7),
        StatisticModel(title: "Title", value: "Value", percentageChange: -74.9)
    ]
     */
    @Published var statistics: [StatisticModel] = []
    
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false //для индикации перезагрузки данных func reloadData() { }
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
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
        
        //update allCoins
        
        $searchText
            .combineLatest(coinDataService.$allCoins) //добавляет еще одного паблюшера
        //задержка для того чтобы при вводе символов с клавиатуры - каждый раз не срабатывала функция фильтрации а только после паузы после 0.5 секунд
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins) //можно сократить до имени функции - в силу того, что параметры мы продублировали из автозаполнения .map - а потом вынесли в отдельную функцию
            .sink { [weak self] (returnedCoin) in
                if let self = self {
                    self.allCoins = returnedCoin
                }
            }
            .store(in: &cancellable)
        
        //update marketData
        
        marketDataService.$marketData
        /*
         оптимизируем код - вынесем логику в private func
            .map { (marketDataModel) -> [StatisticModel] in
                var stats: [StatisticModel] = []
                guard let data = marketDataModel else {
                    return stats
                }
                let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
                let volume = StatisticModel(title: "24h Volume", value: data.volume)
                let btcDominance = StatisticModel(title: "Btc Dominance", value: data.btcDominance)
                let portfolio = StatisticModel(title: "Portfolio Value", value: "$0.00", percentageChange: 0)
                stats.append(contentsOf:
                                [ marketCap,
                                  volume,
                                  btcDominance,
                                  portfolio
                                ]
                )
                return stats
            }
         */
            .combineLatest($portfolioCoins) //добавляем паблюшера для совместного прослушивания
            .map(addMarketData) //если параметры указаны правильно - можно оставить только имя фцнкции
            .sink { [weak self] (returnedStats) in
                if let self = self {
                    self.statistics = returnedStats
                    self.isLoading = false
                }
            }
            .store(in: &cancellable)
        
        //updates portfolioCoins
        //РАЗОБРАТЬ!!!
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
        /*
          вынесем в отдельную функцию
            .map{(coinModels, portfolioEntitys) -> [CoinModel] in
                coinModels
                    .compactMap { (coin) -> CoinModel? in
                        guard let entity = portfolioEntitys.first(where: {$0.coinID == coin.id}) else {
                            return nil
                        }
                        return coin.updateHoldings(amount: entity.amount)
                    }
            }
         */
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] (returnedCoins) in
                if let self = self {
                    self.portfolioCoins = returnedCoins
                }
            }
            .store(in: &cancellable)
        
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    
    func reloadData() {
        //для реализации данной функции пришлось сделать открытыми функции getCoins() в coinDataService и marketDataService
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getCoins()
        HapticManager.notification(type: .success) //добавление тактильной вибрации
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
    
    private func addMarketData(marketDataModel: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
        var stats: [StatisticModel] = []
        guard let data = marketDataModel else {
            return stats
        }
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "Btc Dominance", value: data.btcDominance)
        
        
        let portfolioValue = portfolioCoins.map{$0.currentHoldingsValue}.reduce(0, +) //сумма всех активов в портфеле
        let previousValues =
        portfolioCoins
            .map { (coin) -> Double in
                let currentValue = coin.currentHoldingsValue
                let percentChange = coin.priceChangePercentage24H ?? 0 / 100
                let previousValuers = currentValue / (1 + percentChange)
                return previousValuers
            }
            .reduce(0, +)
        
        let precentageChange = ((portfolioValue - previousValues) / previousValues) * 100
        
        
        let portfolio = StatisticModel(title: "Portfolio Value", value: portfolioValue.asCurrencyWith2Decimals(), percentageChange: precentageChange)
        
        
        
        stats.append(contentsOf:
                        [ marketCap,
                          volume,
                          btcDominance,
                          portfolio
                        ]
        )
        return stats
    }
    
    private func mapAllCoinsToPortfolioCoins(allCoins: [CoinModel], portfolioEntitys: [PortfolioEntity]) -> [CoinModel] {
        allCoins
                .compactMap { (coin) -> CoinModel? in
                    guard let entity = portfolioEntitys.first(where: {$0.coinID == coin.id}) else {
                        return nil
                    }
                    return coin.updateHoldings(amount: entity.amount)
                }
    }
    
}
