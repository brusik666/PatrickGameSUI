//
//  CustomToggleStyle.swift
//  PatrickGameSUI
//
//  Created by Brusik on 10/4/24.
//

import SwiftUI

struct CustomToggleStyle: ToggleStyle {
    
    var color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
                   configuration.label
                       .font(.headline) // Customize the label
                       .foregroundStyle(color)
                   Toggle("", isOn: configuration.$isOn)
                       .labelsHidden() // Hides the default label
                       .foregroundStyle(color)
               }
               .padding(.horizontal)
    }
}
