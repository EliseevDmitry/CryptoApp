//
//  CoinImageViewModel.swift
//  CryptoApp
//
//  Created by Dmitriy Eliseev on 21.12.2024.
//

import Foundation
import SwiftUI
import Combine

final class CoinImageViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    private let coin: CoinModel
    private let service: CoinImageService
    private var cancellables = Set<AnyCancellable>()
    init(coin: CoinModel){
        self.coin = coin
        self.service = CoinImageService(coin: coin)
        self.addSubscribers()
        self.isLoading = true
    }
    private func addSubscribers(){
        service.$image
            .sink { [weak self] (_) in
                if let self = self {
                    self.isLoading = false
                }
            } receiveValue: { [weak self] image in
                if let self = self, let image = image {
                    self.image = image
                    self.isLoading = true
                }
            }
            .store(in: &cancellables)
    }
}
