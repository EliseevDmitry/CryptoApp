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
    let coin: CoinModel
    init(coin: CoinModel) {
        self.coin = coin
        print("Initializing Detail View for \(coin.name)")
    }
    var body: some View {
        Text(coin.name)
    }
}

//MARK: - PREVIEWS
struct DetailView_Previews: PreviewProvider {
    static var previews: some View{
        DetailLoadingView(coin: .constant(dev.coin))
    }
}
