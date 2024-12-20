//
//  CoinRowView.swift
//  CryptoApp
//
//  Created by Dmitriy Eliseev on 20.12.2024.
//

import SwiftUI

//MARK: - VIEW
struct CoinRowView: View {
    @Environment(\.mainWindowSize) var viewSize
    @State var showHoldingsColumn: Bool = true
    let coin: CoinModel
    var body: some View {
            HStack(spacing: 0) {
                leftColumn
                Spacer()
                if showHoldingsColumn {
                    centerColumn
                }
                rightColumn
                    .frame(width: viewSize.width / 3.5, alignment: .trailing)
            }
            .font(.subheadline)
        }
}

//MARK: - EXTENSION
extension CoinRowView {
    private var leftColumn: some View {
        HStack {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
                .frame(minWidth: 30)
            Circle()
                .frame(width: 30, height: 30)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 6)
                .foregroundStyle(Color.theme.accent)
        }
    }
    
    private var centerColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
                .bold()
            Text((coin.currentHoldings ?? 0).asNumberString())
        }
        .foregroundStyle(Color.theme.accent)
    }
    
    private var rightColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentPrice.asCurrencyWith2Decimals())
                .bold()
                .foregroundStyle(Color.theme.accent)
            Text(coin.priceChangePercentage24H?.asPersentString() ?? "0")
                .foregroundStyle(coin.priceChangePercentage24H ?? 0 >= 0 ? Color.theme.green : Color.theme.red)
        }
    }
}

//MARK: - PREVIEW
struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View{
        Group{
            CoinRowView(coin: dev.coin)
                .previewLayout(.sizeThatFits)
                .environment(\.mainWindowSize, dev.windowSize)
            CoinRowView(coin: dev.coin)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
                .environment(\.mainWindowSize, dev.windowSize)
        }
    }
}
