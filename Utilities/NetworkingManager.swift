//
//  NetworkingManager.swift
//  CryptoApp
//
//  Created by Dmitriy Eliseev on 21.12.2024.
//

import Foundation
import Combine

final class NetworkingManager {
    
    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL)
        case unknown
        var errorDescription: String?{
            switch self {
            case .badURLResponse(url: let url):
                return "[🔥] Bad response for URL: \(url)" //control + command + space - токрывает смайлики
            case .unknown:
                return "[⚠️] Unknown error occured"
            }
        }
    }
    
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        
        /*
         изначально если мы захотим вернуть значение этой функции, то ее тип будет:
         Publishers.ReceiveOn<Publishers.TryMap<Publishers.SubscribeOn<URLSession.DataTaskPublisher, DispatchQueue>, Data>, DispatchQueue>
         В этом почти нереально разобраться!
         Но в Combine есть решение преобразование Паблюшера:
         .eraseToAnyPublisher() -> тогда тип возвращаемого значения будет -> AnyPublisher<Data, Error>
         */
        
         URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap({ try handleURLResponse(output: $0, url: url) }) //непонятно как это создавать
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300
        //else {throw URLError(.badServerResponse) } //можно заменить после создания enum
        else { throw NetworkingError.badURLResponse(url: url) }
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>){
        switch completion  {
        case .finished:
            break
        case.failure(let error):
            print(error.localizedDescription)
        }
    }
    
}
