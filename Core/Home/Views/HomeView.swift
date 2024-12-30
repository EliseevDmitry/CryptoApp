//
//  HomeView.swift
//  CryptoApp
//
//  Created by Dmitriy Eliseev on 20.12.2024.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var vm: HomeViewModel
    @Environment(\.mainWindowSize) var viewSize
    @State private var showPortfolio: Bool = false
    @State private var showPortfolioView: Bool = false
    
    //две переменные, которые будут реализовывать кастомную навигацию на DetailView
    @State private var selectedCoin: CoinModel? = nil
    @State private var showDetailView: Bool = false
    @State private var showSettingsView: Bool = false
    
    var body: some View {
        ZStack{
            //background layer
            Color.theme.background
                .ignoresSafeArea()
            //добавляет новый лист к фону
                .sheet(isPresented: $showPortfolioView, content: {
                    PortfolioView()
                    //  .environmentObject(vm) //проверим нужно ли тут пробрасывать!?
                })
            
            //content layer
            VStack{
                homeHeader //очень хорошая практика - выносить в отдельные extension (блоки кода)
                HomeStatusViews(showPortfolio: $showPortfolio)
                SearchBarView(searchText: $vm.searchText)
                columnTitles
                if !showPortfolio {
                    allCoinsList
                        .transition(.move(edge: .leading))
                }
                if showPortfolio {
                    portfolioCoinsList
                        .transition(.move(edge: .trailing))
                }
                Spacer(minLength: 0)
            }
            .sheet(isPresented: $showSettingsView) {
                SettingsView()
            }
        }
        //этот блок позволяет на новый экран через реализованную функцию func segue(coin: CoinModel) { } - обойти проблему инициализации DetailView() в списке List ()
        .background()
        .navigationDestination(isPresented: $showDetailView) {
            //DetailView(coin: $selectedCoin) - заменяем на
            DetailLoadingView(coin: $selectedCoin)
        }
        
        
       
    }
}
    

//очень хорошая практика - выносить в отдельные extension (блоки кода)
extension HomeView {
    private var homeHeader: some View{
        HStack{
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(.none, value: showPortfolio)
                .background(
                    CircleButtonAnimationView(animate: $showPortfolio)
                )
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioView.toggle()
                    } else {
                        showSettingsView.toggle()
                    }
                }
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundStyle(Color.theme.accent)
                .animation(.none, value: showPortfolio)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    
    private var allCoinsList: some View {
        List {
            ForEach(vm.allCoins){ item in
                //основная проблема использования NavigationLink - заключается в том, что данные станицы по этой ссылке загружаются в память еще до перехода на страницу, при чем для всех активных в рамках видимости items на экране. При скролинге - загрузка данных продолжается!!! Использование - данного формата в проектах недопустимо!
                //                NavigationLink {
                //                    DetailView()
                //                } label: {
                //                    CoinRowView(showHoldingsColumn: false, coin: item)
                //                    //инициализация отступов в LIST!!!
                //                        .listRowInsets(.init(top: 10, leading: 0, bottom: 0, trailing: 10))
                //                
                //                }
             
                    CoinRowView(showHoldingsColumn: false, coin: item)
                    //инициализация отступов в LIST!!!
                        .listRowInsets(.init(top: 10, leading: 0, bottom: 0, trailing: 10))
                    .onTapGesture {
                        segue(coin: item)
                    }
            }
            
        }
        .listStyle(PlainListStyle())
    }
    
    private func segue(coin: CoinModel) {
        selectedCoin = coin
        showDetailView.toggle()
    }
    
    private var portfolioCoinsList: some View {
        List {
            ForEach(vm.portfolioCoins){ item in
                CoinRowView(showHoldingsColumn: true, coin: item)
                //инициализация отступов в LIST!!!
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 0, trailing: 10))
            }
            
        }
        .listStyle(PlainListStyle())
    }
    
    private var columnTitles: some View {
        HStack{
            HStack (spacing: 4){
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortoptions == .rank || vm.sortoptions == .rankReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortoptions == .rank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortoptions = vm.sortoptions == .rank ? .rankReversed : .rank //инверсия значений (КРУТО!)
                }
            }
            Spacer()
            if showPortfolio {
                HStack (spacing: 4){
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity((vm.sortoptions == .holdings || vm.sortoptions == .holdingsReversed) ? 1.0 : 0.0)
                        .rotationEffect(Angle(degrees: vm.sortoptions == .holdings ? 0 : 180))
                }
                .onTapGesture {
                    withAnimation(.default) {
                        vm.sortoptions = vm.sortoptions == .holdings ? .holdingsReversed : .holdings
                    }
                }
            }
            HStack (spacing: 4){
                Text("Price")
                    .frame(width: viewSize.width / 3.5, alignment: .trailing)
                Image(systemName: "chevron.down")
                    .opacity((vm.sortoptions == .price || vm.sortoptions == .priceReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortoptions == .price ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortoptions = vm.sortoptions == .price ? .priceReversed : .price
                }
            }
            Button {
                withAnimation {
                    vm.reloadData()
                }
            } label: {
                Image(systemName: "goforward")
                    .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0))
            }
            
        }
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryText)
        .padding(.horizontal)
    }
    
}

//MARK: - PREVIEWS
struct HomeView_Previews: PreviewProvider {
    static var previews: some View{
        NavigationStack{
            HomeView()
                .toolbar(.hidden)
        }
        .environmentObject(dev.homeVM)
        .environment(\.mainWindowSize, dev.windowSize)
    }
}
