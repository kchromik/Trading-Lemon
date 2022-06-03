//
//  SearchView.swift
//  Trading Lemon
//
//  Created by Kevin Chromik on 20.05.22.
//

import SwiftUI

struct SearchView: View {

    @StateObject var tradingManager: TradingManager
    @State var searchTerm: String = ""

    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    EmptyView()
                        .background(.black)

                    TextField("", text: $searchTerm)
                        .placeholder(when: searchTerm.isEmpty) {
                            Text("Name/Title, ISIN or WKN").italic().foregroundColor(Color(UIColor.lightGray))
                    }
                        .onChange(of: searchTerm, perform: { newValue in
                            Task {
                                try await tradingManager.searchInstrument(with: newValue.replacingOccurrences(of: " ", with: ""))
                            }
                        })
                        .foregroundColor(AppConfig.lightText)
                        .font(.system(size: 25, weight: .heavy, design: .default))
                        .padding()
                        .background(AppConfig.lightBackground)
                }

                if tradingManager.searchResults.isEmpty {
                    Spacer()
                    Text("Search for stocks 👆")
                        .italic()
                        .foregroundColor(AppConfig.lightText)
                    Spacer()
                } else {
                    ScrollView {
                        ForEach(tradingManager.searchResults, id: \.isin) { instrument in
                            NavigationLink {
                                InstrumentDetailView(tradingManager: tradingManager, instrument: instrument)
                            } label: {
                                SearchResultItemView(instrument: instrument)
                            }
                        }
                    }
                    .padding([.leading, .trailing], 8)
                }
            }
            .background(AppConfig.darkBackground)
            .navigationTitle("Search")
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(tradingManager: TradingManager())
    }
}
