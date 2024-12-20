//
//  EnvironmentValues.swift
//  CryptoApp
//
//  Created by Dmitriy Eliseev on 20.12.2024.
//

import SwiftUI

/*
 Это расширение создано заменить утратившей свою силу модификатор
 .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
 
 мы вычисляем через  GeometryReader { } - размер экрана в CryptoAppApp и передаем его через
 .environment(\.mainWindowSize, geometry.size)
 
 предварительно создав ключ - mainWindowSize
 
 также в расширении PreviewProvider - создана катомная статическая константа с разрешением экрана для iPhone16
 let windowSize = CGSize(width: 393, height: 759)
 */

struct MainWindowSizeKey: EnvironmentKey {
    static let defaultValue: CGSize = CGSize(width: 0, height: 0)
}

extension EnvironmentValues {
    var mainWindowSize: CGSize {
        get { self[MainWindowSizeKey.self] }
        set { self[MainWindowSizeKey.self] = newValue }
    }
}
