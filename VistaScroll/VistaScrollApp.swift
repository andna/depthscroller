//
//  VistaScrollApp.swift
//  VistaScroll
//
//  Created by Andres Bastidas on 11/09/24.
//

import SwiftUI

@main
struct VistaScrollApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.windowStyle(.plain)

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}
