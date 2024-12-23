//
//  PortfolioView.swift
//  CryptoApp
//
//  Created by Dmitriy Eliseev on 23.12.2024.
//

import SwiftUI

struct PortfolioView: View {
    @EnvironmentObject private var vm: HomeViewModel
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantityText: String = ""
    @State private var showCheckmark: Bool = false
    var body: some View {
        //идея в том - что это уже следующий уровень иерархии view и требуется заново делать обертку NavigationView { } - не работает с @Environment(\.dismiss) var dismiss - пришлось заменить на NavigationStack { }
        //Для обработки dismiss - потребовалось обернуть PortfolioView() в -> NavigationStack { }
        NavigationStack {
            ScrollView{
                VStack(alignment: .leading, spacing: 0) {
                    SearchBarView(searchText: $vm.searchText)
                    coinLogoList
                    if selectedCoin != nil {
                        portfolioInputSection
                    }
                }
            }
            .navigationTitle("Edit Portfolio")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    XMarkButton()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    trailingNavBarButtons
                }
            }
        }
    }
}

extension PortfolioView {
    private var coinLogoList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10){
                ForEach(vm.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding()
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                selectedCoin = coin
                            }
                        }
                        .background (
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: selectedCoin?.id == coin.id ? 1 : 0)
                                .foregroundStyle(selectedCoin?.id == coin.id ? Color.theme.green : Color.clear)
                        )
                }
            }
        }
        .frame(height: 120)
        .padding(.leading) // отступ от края экрана
    }
    
    private func getCurrentValue() -> Double {
        if let quantity = Double(quantityText) {
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0.0
    }
    
    private var portfolioInputSection: some View {
        VStack(spacing: 20){
            HStack{
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }
            Divider()
            HStack{
                Text("Amount holding:")
                Spacer()
                TextField("Ex: 1.4", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack{
                Text("Current value:")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
        }
        .animation(nil, value: 0) //замена .animation(.none)
        .padding()
        .font(.headline)
    }
    
    private func saveButtonPressed(){
        guard let coin = selectedCoin else { return }
        //save to portfolio
        print(coin)
        
        //show checkmark
        withAnimation(.easeIn) {
            showCheckmark = true
            removeSelectedCoin()
        }
        
        //hide keyboard
        UIApplication.shared.endEditing()
        
        //hide checkmark
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            withAnimation(.easeOut) {
                showCheckmark = false
            }
        }
    }
    
    private func removeSelectedCoin(){
        selectedCoin = nil
        vm.searchText = ""
    }
    
    private var trailingNavBarButtons: some View {
        HStack(spacing: 10){
            Image(systemName: "checkmark")
                .opacity(showCheckmark ? 1.0 : 0.0)
            Button("Save".uppercased()) {
                saveButtonPressed()
            }
            .opacity(selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText) ? 1.0 : 0.0
            )
        }
        .font(.headline)
    }
    
}

//MARK: - PREVIEW
struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View{
        PortfolioView()
            .environmentObject(dev.homeVM)
    }
}
