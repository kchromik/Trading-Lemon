//
//  OrderView.swift
//  Trading Lemon
//
//  Created by Kevin Chromik on 03.06.22.
//

import SwiftUI

struct OrderView: View {

    let order: Order

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(order.title ?? "N/A").bold()
                    .foregroundColor(AppConfig.lightText)
                Text(order.status)
                    .italic()
                    .foregroundColor(order.status == "inactive" ? AppConfig.tint : .gray)
            }

            Spacer()
            VStack(alignment: .trailing) {
                Text(order.side)
                    .foregroundColor(AppConfig.lightText)
                Text("Quantity \(order.quantity ?? -1)")
                    .foregroundColor(AppConfig.lightText)
            }
        }
        .padding().background(RoundedRectangle(cornerRadius: 10).foregroundColor(AppConfig.lightBackground))
    }
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        OrderView(order: Order(id: "", status: "", side: "", title: "", quantity: 11))
    }
}
