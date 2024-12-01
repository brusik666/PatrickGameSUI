//
//  GameSettingsView.swift
//  PatrickGameSUI
//
//  Created by Brusik on 10/3/24.
//

import SwiftUI

struct GameSettingsView: View {
    
    @State private var isSoundOn = true
    @State private var isMusicOn = true
    
    var body: some View {
        ZStack {
            BackgroundImage()
            VStack {
                HStack {
                    Toggle(isOn: $isSoundOn, label: {
                        Text("Sound")
                    })
                }
                HStack {
                    Toggle(isOn: $isMusicOn, label: {
                        Text("Music")
                    })
                }
                
            }
            .toggleStyle(CustomToggleStyle(color: .red))
        }

    }
}

#Preview {
    GameSettingsView()
}
