//
//  PortfolioDataService.swift
//  CryptoApp
//
//  Created by Dmitriy Eliseev on 24.12.2024.
//

import Foundation
import CoreData

final class PortfolioDataService {
    
    private let container: NSPersistentContainer
    private let containerName: String = "PortfolioContainer"
    private let entityName: String = "PortfolioEntity"
    @Published var savedEntities: [PortfolioEntity] = []
    
    init(){
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loadind Core Data! \(error)")
            }
        }
        //получение данных из CoreDatа при загрузке (инициализации)
        getPortfolio()
    }
    
    //MARK: - PUBLIC
    /*
     Универсальная функция обновления даных в портфолио криптовалют, функция позволяет - CUD
     */
    func updatePortfolio(coin: CoinModel, amount: Double) {
        //check if coin already in portfolio
        if let entity = savedEntities.first(where: {$0.coinID == coin.id }) {
            if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                delete(entity: entity)
            }
        } else {
            add(coin: coin, amount: amount)
        }
    }
    
    //MARK: - PRIVATE
    private func getPortfolio(){
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        do{
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error feching Portfolio Entities. \(error)")
        }
    }
    
    private func add(coin: CoinModel, amount: Double){
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        applyChanges()
    }
    
    private func update(entity: PortfolioEntity, amount: Double){
        entity.amount = amount
        applyChanges()
    }
    
    private func delete(entity: PortfolioEntity){
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func save(){
        do{
            try container.viewContext.save()
        } catch let error {
            print("Error saving to Core Data. \(error)")
        }
    }
    
    private func applyChanges(){
        save()
        getPortfolio()
    }
    
}
