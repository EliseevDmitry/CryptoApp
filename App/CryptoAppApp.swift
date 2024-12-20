//
//  CryptoAppApp.swift
//  CryptoApp
//
//  Created by Dmitriy Eliseev on 19.12.2024.
//

import SwiftUI
/*
 В Targets -> Display Name -> Crypto Tracker (то как приложение будет называться на Iphone)
 */

@main
struct CryptoAppApp: App {
    @StateObject private var vm = HomeViewModel()
    var body: some Scene {
        WindowGroup {
            //сразу для приложения определяем "NavigationView"
            GeometryReader { geometry in
                NavigationView {
                    HomeView()
                        .toolbar(.hidden) //скрываем панель toolBar
                    
                }
                .environmentObject(vm)
                .environment(\.mainWindowSize, geometry.size)
            }
        }
    }
}
