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
    @State private var showLaunchView = true
    
    //инициализация цвета заголовка для всего приложения UINavigationBar
    init(){
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        UITableView.appearance().backgroundColor = UIColor.clear
        
    }
    
    var body: some Scene {
        WindowGroup {
            //сразу для приложения определяем "NavigationView"
            GeometryReader { geometry in
                ZStack{
                    NavigationStack {
                        HomeView()
                            .toolbar(.hidden) //скрываем панель toolBar
                    }
                    /*
                     //.navigationViewStyle(StackNavigationViewStyle())
                     этот модификатор добавляется для корректного отображения на Ipad - при использовании NavigationView, однако при использовании NavigationStack - отображается все и так корректно!
                     */
                    .environmentObject(vm)
                    .environment(\.mainWindowSize, geometry.size)
                    /*
                     showLaunchView - меняется на false в LaunchView.swift через @Binding свойство, а условие проверки false/true  написаны в этом view
                     */
                    ZStack{
                        if showLaunchView {
                            LaunchView(showLaunchView: $showLaunchView) //точная копия LaunchScreen.storyboard (делаем задержку загрузочного экрана)
                                .transition(.move(edge: .leading))
                        }
                    }
                    .zIndex(2.0)
                    /*
                     .zIndex() используется для управления порядком наложения (слоёв) в представлениях, когда они находятся на одном уровне в интерфейсе. Чем выше значение zIndex, тем выше будет расположено представление по отношению к другим.
                     гарантировано размещаем ZStack{ } - сверху другого представления!!!
                     */
                }
            }
        }
    }
}
