//
//  CoinImageService.swift
//  CryptoApp
//
//  Created by Dmitriy Eliseev on 21.12.2024.
//

import Foundation
import SwiftUI
import Combine

final class CoinImageService {
    @Published var image: UIImage? = nil
    private var cancellables: AnyCancellable?
    
    private let coin: CoinModel
    
    init(coin: CoinModel){
        self.coin = coin
        getCoinImage()
    }
    
    private func getCoinImage(){
        guard let url = URL(string: coin.image) else { return }
        cancellables = NetworkingManager.download(url: url) //Оптимизация кода
            .tryMap({ (data)  -> UIImage? in
                UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedImage) in
                guard let self = self else { return }
                self.image = returnedImage
                self.cancellables?.cancel() //завершаем паблешера по завершению получения данных
            })
    }
    
}
