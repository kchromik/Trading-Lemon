//
//  TitleDetailView.swift
//  Trading Lemon
//
//  Created by Kevin Chromik on 03.06.22.
//

import SwiftUI

struct TitleDetailView: View {

    let title: String
    let detail: String

    var body: some View {
        HStack {
            Text(title).bold()
                .foregroundColor(AppConfig.lightText)
            Spacer()
            Text(detail)
                .foregroundColor(AppConfig.lightText)
        }
        .listRowBackground(AppConfig.darkBackground)
        

    }
}

struct TitleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TitleDetailView(title: "Amount", detail: "4000")
    }
}
