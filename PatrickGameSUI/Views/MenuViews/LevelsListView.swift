//
//  LevelsListView.swift
//  PatrickGameSUI
//
//  Created by Brusik on 10/3/24.
//

import SwiftUI

struct LevelsListView: View {
    var body: some View {
        GeometryReader { geometry in
            
            let circleHeight = geometry.size.height / 2
            ZStack {
                Circle()
                    .strokeBorder(lineWidth: 2)
                    .frame(height: circleHeight)
                VStack {
                    Text("John and")
                        .font(.system(size: 30))
                        .fontWeight(.heavy)
                    Text("Dima Brusov")
                        .font(.system(size: 20))
                        .fontWeight(.regular)
                }
                .foregroundStyle(.cyan)
                //.clipShape(Circle())
            .frame(width: 200, height: 200)
            }
        }
        
        
    }
}

#Preview {
    LevelsListView()
}
