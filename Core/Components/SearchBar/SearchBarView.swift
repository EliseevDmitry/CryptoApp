//
//  SearchBarView.swift
//  CryptoApp
//
//  Created by Dmitriy Eliseev on 22.12.2024.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    var body: some View {
        HStack{
            Image(systemName: "magnifyingglass")
                .foregroundStyle(
                    searchText.isEmpty ? Color.theme.secondaryText : Color.theme.accent
                )
            TextField("Search by name or symbol ...", text: $searchText)
                .foregroundStyle(Color.theme.accent)
            //не работает выключение автокоррекции
                .autocorrectionDisabled(true) //выключение автозамены на выезжающей клавиатуре
                .keyboardType(.default)
                .overlay (
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .offset(x: 10)
                        .foregroundStyle(Color.theme.accent)
                        .opacity(searchText.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            UIApplication.shared.endEditing() //скрытие клавиатуры - реализовывается через расширение UIApplication
                            searchText = ""
                        }
                    , alignment: .trailing
                )
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.theme.background)
                .shadow(
                    color: Color.theme.accent.opacity(0.15),
                    radius: 10,
                    x: 0,
                    y: 0
                )
        )
        .padding()
    }
}

//MARK: - PREVIEWS
struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View{
        Group{
            SearchBarView(searchText: .constant(""))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)
            SearchBarView(searchText: .constant(""))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
