//
//  LogoView.swift
//  EagleEatsFinalProject
//
//  Created by Halen Hickman-Goveia on 9/4/24.
//

import SwiftUI

struct LogoView: View {
    var body: some View {
        Image("logo")
            .resizable()
            .scaledToFit()
            .frame(width: 150)
            .padding()
    }
}

#Preview {
    LogoView()
}
