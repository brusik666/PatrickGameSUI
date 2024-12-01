//
//  MainMenuView.swift
//  PatrickGameSUI
//
//  Created by Brusik on 10/3/24.
//

import SwiftUI

struct MainMenuView: View {
    var body: some View {
        NavigationSplitView {
            ZStack {
                 BackgroundImage()
                VStack(spacing: 15){
                    HStack {
                        Spacer()
                        NavigationLink {
                            DailyBonusView()
                        } label: {
                            Image(ImageName.Buttons.dailyBonusButton.rawValue)
                        }
                    }
                    
                    NavigationLink {
                        GameView()
                    } label: {
                        Image(ImageName.Buttons.playButton.rawValue)
                    }
                    
                    NavigationLink {
                        GameSettingsView()
                    } label: {
                        Image(ImageName.Buttons.settingsButton.rawValue)
                    }
                    
                    NavigationLink {
                        GameShopView()
                    } label: {
                        Image(ImageName.Buttons.shopButton.rawValue)
                    }
                }
            }
        } detail: {
            Text("MENU")
        }
    }
}

#Preview {
    MainMenuView()
}

struct BackgroundImage: View {
    var body: some View {
        Image(ImageName.Backgrounds.background.rawValue)
            .resizable()
            .ignoresSafeArea()
    }
}
