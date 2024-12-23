//
//  HomeStatusViews.swift
//  CryptoApp
//
//  Created by Dmitriy Eliseev on 23.12.2024.
//

import SwiftUI

struct HomeStatusViews: View {
    @EnvironmentObject private var vm: HomeViewModel
    @Binding var showPortfolio: Bool
    @Environment(\.mainWindowSize) private var windowSize
    var body: some View {
        HStack {
            ForEach(vm.statistics) { item in
                StatisticView(stat: item)
                    .frame(width: windowSize.width / 3)
            }
        }
        .frame(width: windowSize.width, alignment: showPortfolio ? .trailing : .leading)
    }
}

//MARK: - PREVIEWS
struct HomeStatusViews_Previews: PreviewProvider {
    static var previews: some View{
        HomeStatusViews(showPortfolio: .constant(true))
            .environmentObject(dev.homeVM)
    }
}
