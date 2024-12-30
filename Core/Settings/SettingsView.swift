//
//  SettingsView.swift
//  CryptoApp
//
//  Created by Dmitriy Eliseev on 29.12.2024.
//

import SwiftUI

struct SettingsView: View {
    let defaultURL = URL(string: "https://www.google.com")!
    let youtubeURL = URL(string: "https://www.youtube.com/c/swiftfulthinking")!
    let coffeeURL = URL(string: "https://www.buymeacoffee.com/nicksarno")!
    let coingeckoURL = URL(string: "https://www.coingecko.com")!
    let personalURL = URL(string: "https://www.nicksarno.com")!
    var body: some View {
        NavigationStack{
            List {
                swiftfulThinkingSection
            }
            
            .font(.headline)
            .tint(.blue)
            .listStyle(GroupedListStyle())
            //.navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarLeading, content: {
                    XMarkButton()
                })
            }
        }
    }
}

#Preview {
    SettingsView()
}

extension SettingsView {
    
    private var swiftfulThinkingSection: some View {
        //у секции как у UITableView - есть header и footer
        Section(header: Text("Swiftful Thinking")) {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app was made by following a @SwiftfulThinking course on YouTube. It uses MVVM Architecture, Combine, and CoreData!")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.theme.accent)
            }
            .padding()
            Link("Subscribe on YouTube", destination: youtubeURL)
            Link("Support his coffee addiction", destination: coffeeURL)
        }
    }
}
