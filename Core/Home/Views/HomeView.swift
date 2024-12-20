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
    var body: some View {
        ZStack{
            //background layer
            Color.theme.background
                .ignoresSafeArea()
            //content layer
            VStack{
                homeHeader //очень хорошая практика - выносить в отдельные extension (блоки кода)
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
                CoinRowView(showHoldingsColumn: false, coin: item)
                //инициализация отступов в LIST!!!
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 0, trailing: 10))
            }
            
        }
        .listStyle(PlainListStyle())
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
            Text("Coin")
            Spacer()
            if showPortfolio {
                Text("Holdings")
            }
            Text("Price")
                .frame(width: viewSize.width / 3.5, alignment: .trailing)
        }
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryText)
        .padding(.horizontal)
    }
    
}

//MARK: - PREVIEWS
struct HomeView_Previews: PreviewProvider {
    static var previews: some View{
        NavigationView{
            HomeView()
                .toolbar(.hidden)
        }
        .environmentObject(dev.homeVM)
        .environment(\.mainWindowSize, dev.windowSize)
    }
}
