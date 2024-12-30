//
//  DetailView.swift
//  CryptoApp
//
//  Created by Dmitriy Eliseev on 27.12.2024.
//

import SwiftUI

/*
 эта структура - является элементом входа в DetailView - куда передается coin и где выполняется отрисовка интерфейса
 При реализации List() в HomeView - все равно срабатывает 2-3 раза print("инициализируется только при переходе") - в структуре DetailLoadingView() однако мы изолировали List() в HomeView от отрисовки экрана и сделали это только при переходе. Даже при скролле в HomeView новые данные не прогружаются
 */
struct DetailLoadingView: View {
    @Binding var coin: CoinModel?
    //Инициализация @___ свойств wrappedValue
    //    init(coin: Binding<CoinModel?>) {
    //        self._coin = coin
    //        print("Initializing Detail View for \(coin.wrappedValue?.name)")
    //    }
    init (coin: Binding<CoinModel?>){
        self._coin = coin
        print("инициализируется только при переходе")
    }
    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
    }
}



struct DetailView: View {
    /*
     пробовали работу NavigationLink со списком и скроллингом
     init(){
     print("NavigationLink - мы не перешли на экран но он уже создан!")
     }
     */
    @StateObject var vm: DetailViewModel
    @State private var showFullDescription: Bool = false
    // let coin: CoinModel
    init(coin: CoinModel) {
        //self.coin = coin
        self._vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
        print("Initializing Detail View for \(coin.name)")
    }
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    private let spacing: CGFloat = 30
    
    var body: some View {
        ScrollView{
            VStack(spacing: 20) {
                ChartView(coin: vm.coin)
                    .padding(.vertical)
                overviewTitle
                Divider()
                descriptionSection //
                Divider()
                overviewGrid
                additionalTitle
                Divider()
                additionalGrid
                webSiteSection
            }
            .padding()
        }
        .navigationTitle(vm.coin.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                navigationItemToolBar
            }
        }
        
        
    }
}

//MARK: - PREVIEWS
struct DetailView_Previews: PreviewProvider {
    static var previews: some View{
        DetailLoadingView(coin: .constant(dev.coin))
    }
}


extension DetailView {
    
    private var navigationItemToolBar: some View {
        
        HStack{
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
                .foregroundStyle(Color.theme.secondaryText)
            CoinImageView(coin: vm.coin)
                .frame(width: 25, height: 25)
        }
    }
    
    private var overviewTitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var additionalTitle: some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var overviewGrid: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: nil,
            pinnedViews: []) {
                ForEach(vm.overviewStatistics) { stat in
                    StatisticView(stat: stat)
                }
            }
    }
    
    private var additionalGrid: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: nil,
            pinnedViews: []) {
                ForEach(vm.additionalStatistics) { stat in
                    StatisticView(stat: stat)
                }
            }
    }
    
    private var descriptionSection: some View {
        ZStack{
            if let coinDescription = vm.coinDescription,
               !coinDescription.isEmpty {
                VStack(alignment: .leading){
                    Text(coinDescription)
                        .lineLimit(showFullDescription ? nil : 3)
                        .font(.callout)
                        .foregroundStyle(Color.theme.secondaryText)
                    Button {
                        withAnimation(.easeInOut){
                            showFullDescription.toggle()
                        }
                    } label: {
                        Text(showFullDescription ? "Less" : "Read more ...")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical, 4)
                    }
                    .tint(.blue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    private var webSiteSection: some View {
        VStack (alignment: .leading, spacing: 20) {
            if let websiteString = vm.websiteURL,
               let url = URL(string: websiteString) {
                Link("Website", destination: url)
            }
            
            if let redditString = vm.redditURL,
               let url = URL(string: redditString) {
                Link("Reddit", destination: url)
            }
        }
        .tint(.blue)
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.headline)
    }
}
