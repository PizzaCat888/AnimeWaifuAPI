//
//  ContentView.swift
//  WaifuOrNot
//
//  Created by Wei Chang Lin on 2023-01-01.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MainView().tabItem {
                Label("Waifus", systemImage: "star.leadinghalf.filled")
            }
            
            LikesView().tabItem {
                Label("Likes", systemImage: "star.leadinghalf.filled")
            }
            
            DonateView().tabItem {
                Label("Donate", systemImage: "star.leadinghalf.filled")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
