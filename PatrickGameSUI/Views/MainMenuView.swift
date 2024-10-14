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
                            Image(ImageNames.dailyBonusButton.rawValue)
                        }
                    }
                    
                    NavigationLink {
                        LevelsListView()
                    } label: {
                        Image(ImageNames.playButton.rawValue)
                    }
                    
                    NavigationLink {
                        GameSettingsView()
                    } label: {
                        Image(ImageNames.settingsButton.rawValue)
                    }
                    
                    NavigationLink {
                        GameShopView()
                    } label: {
                        Image(ImageNames.shopButton.rawValue)
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
        Image(ImageNames.background.rawValue)
            .resizable()
            .ignoresSafeArea()
    }
}
