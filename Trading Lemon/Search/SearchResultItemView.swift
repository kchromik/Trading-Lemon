//
//  SearchResultItemView.swift
//  Trading Lemon
//
//  Created by Kevin Chromik on 20.05.22.
//

import SwiftUI

struct SearchResultItemView: View {

    let instrument: Instrument

    var body: some View {
        HStack {
            VStack {
                Text(instrument.title).bold().foregroundColor(AppConfig.lightText)
                Text(instrument.isin).foregroundColor(AppConfig.lightText)
            }
            Spacer()

            VStack(alignment: .leading) {
                Text(instrument.type.uppercased()).bold().foregroundColor(AppConfig.lightText)

                Text(instrument.symbol).foregroundColor(AppConfig.lightText)

            }
        }
        .padding().background(RoundedRectangle(cornerRadius: 10).foregroundColor(AppConfig.lightBackground))
    }
}

struct SearchResultItemView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultItemView(instrument: Instrument(isin: "US90184L1026", wkn: "A1W6XZ", name: "TWITTER INC. DL-,000005", title: "TWITTER INC.", symbol: "TWR", type: "stock", venues: []))
    }
}
