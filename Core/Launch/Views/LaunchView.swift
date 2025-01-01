//
//  LaunchView.swift
//  CryptoApp
//
//  Created by Dmitriy Eliseev on 01.01.2025.
//

import SwiftUI

struct LaunchView: View {
    @State private var loadingText: [Character] = Array("Loading your portfolio ...")
    @State private var showLoadingText: Bool = false
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State private var counter: Int = 0
   
    @State private var loops: Int = 0
    @Binding var showLaunchView: Bool
    
    var body: some View {
        ZStack {
            Color.launch.background
                .ignoresSafeArea()
            Image(.logoTransparent)
                .resizable()
                .frame(width: 100, height: 100)
            ZStack {
                if showLoadingText {
                    HStack(spacing: 0) {
                        ForEach(0..<loadingText.count, id: \.self) { index in
                            Text(String(loadingText[index]))
                                .font(.headline)
                                .fontWeight(.heavy)
                                .foregroundStyle(Color.launch.accent)
                                .offset(y: counter == index ? -5 : 0)
                        }
                    }
                    .transition(AnyTransition.scale.animation(.easeIn))
                }
            }
            .offset(y: 70)
        }
        .onAppear {
            showLoadingText.toggle()
        }
        .onReceive(timer) { _ in
            withAnimation(.spring()) {
                let lastIndex = loadingText.count - 1
                if counter == lastIndex {
                    counter = 0
                    loops += 1
                    if loops >= 2 {
                        showLaunchView = false
                    }
                } else {
                    counter += 1
                }
            }
        }
    }
}

//MARK: - PREVIEWS
struct LaunchView_Previews: PreviewProvider {
    static var previews: some View{
        LaunchView(showLaunchView: .constant(true))
    }
}
