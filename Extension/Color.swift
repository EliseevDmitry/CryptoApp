//
//  Color.swift
//  CryptoApp
//
//  Created by Dmitriy Eliseev on 19.12.2024.
//

import SwiftUI

extension Color {
    static let theme = ColorTheme()
    static let launch = LaunhTheme()
}

struct ColorTheme {
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let green = Color("GreenColor")
    let red = Color("RedColor")
    let secondaryText = Color("SecondaryTextColor")
}

/*
 Вся фишка этой конструкции - можно копировать структуру ColorTheme - и создать очень быстро альтернативную тему для приложения заменим цвета
 */


struct LaunhTheme {
    let accent = Color("LaunchAccentColor")
    let background = Color("LaunchBackgroundColor")
}
