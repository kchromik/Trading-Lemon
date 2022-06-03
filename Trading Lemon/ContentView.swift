//
//  ContentView.swift
//  Trading Lemon
//
//  Created by Kevin Chromik on 30.03.22.
//

import SwiftUI

struct ContentView: View {

    private let tradingManager = TradingManager()

    init() {
        UITabBar.appearance().backgroundColor = UIColor(AppConfig.lightBackground)
        UITabBar.appearance().barTintColor = .gray
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]

        UITableViewCell.appearance().backgroundColor = UIColor(AppConfig.darkBackground)
        UITableView.appearance().backgroundColor = UIColor(AppConfig.darkBackground)

        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(AppConfig.tint)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(AppConfig.tint)], for: .normal)
    }

    var body: some View {
        TabView {
            AccountView(tradingManager: tradingManager)
                .tabItem {
                    Label("Dashboard", systemImage: "person.crop.circle.fill")
                }
            SearchView(tradingManager: tradingManager)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            OrdersView(tradingManager: tradingManager)
                .tabItem {
                    Label("Orders", systemImage: "bag")
                }
        }
        .accentColor(AppConfig.tint)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
