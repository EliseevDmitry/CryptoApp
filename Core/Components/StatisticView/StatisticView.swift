//
//  StatisticView.swift
//  CryptoApp
//
//  Created by Dmitriy Eliseev on 23.12.2024.
//

import SwiftUI

struct StatisticView: View {
    let stat: StatisticModel
    var body: some View {
        VStack(alignment: .leading, spacing: 4){
            Text(stat.title)
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
            Text(Double(stat.value)?.formattedWithAbbreviations() ?? "\(stat.value)")
                .font(.headline)
                .foregroundStyle(Color.theme.accent)
            HStack(spacing: 4){
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect((stat.percentageChange ?? 0) >= 0 ? .zero : Angle(degrees: 180))
                Text(stat.percentageChange?.asPersentString() ?? "")
                    .font(.caption)
                    .bold()
            }
            .foregroundStyle((stat.percentageChange ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
            .opacity(stat.percentageChange == nil ? 0.0 : 1.0)
        }
    }
}

//MARK: - PREVIEWS
struct StatisticView_Previews: PreviewProvider {
    static var previews: some View{
        Group{
            StatisticView(stat: dev.stat[0])
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)
            StatisticView(stat: dev.stat[1])
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
            StatisticView(stat: dev.stat[2])
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
