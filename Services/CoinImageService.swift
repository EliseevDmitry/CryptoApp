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
    private let fileManager = LocalFileManager.instance
    private let folderName = "coin_images"
    private let imageName: String
    
    init(coin: CoinModel){
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    //проверяем - если ли сохраненное изображение в папке устройства, и если нет обращаемся в сеть
    private func getCoinImage() {
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
            image = savedImage
            print("Retrieved image from File Manager!")
        } else {
            downloadCoinImage()
            print("Downloading image now")
        }
    }
    
    private func downloadCoinImage(){
        guard let url = URL(string: coin.image) else { return }
        cancellables = NetworkingManager.download(url: url) //Оптимизация кода
            .tryMap({ (data)  -> UIImage? in
                UIImage(data: data)
            })
            .receive(on: DispatchQueue.main) //переходим в main поток тут, (refactor NetworkingManager)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedImage) in
                guard
                    let self = self,
                    let downloadedImage = returnedImage
                else { return }
                self.image = downloadedImage
                self.cancellables?.cancel() //завершаем паблешера по завершению получения данных
                //сохраняем изображение загруженное из сети в папке
                fileManager.saveImage(image: downloadedImage, imageName: imageName, folderName: folderName)
            })
    }
    
}
