//
//  CustomNumberInputView.swift
//  Trading Lemon
//
//  Created by Kevin Chromik on 20.05.22.
//

import SwiftUI

/// Custom Numbers Input
struct CustomNumberInputView: View {

    @Binding var amount: Int
    @State var fontSize: CGFloat = 45
    @State var color: Color = .white
    @State private var formattedNumber: String = ""
    private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    private let numbers = ["7", "8", "9", "4", "5", "6", "1", "2", "3", "", "0", "<"]

    // MARK: - Main rendering function
    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(0..<numbers.count, id: \.self, content: { index in
                Button(action: {
                    if numbers[index] == "<" {
                        formattedNumber = "\(formattedNumber.dropLast())"
                    } else {
                        formattedNumber.append(numbers[index])
                    }
                    if let integerValue = Int(formattedNumber) {
                        amount = integerValue
                    } else {
                        amount = 0
                    }
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }, label: {
                    if numbers[index] == "<" {
                        Image(systemName: "arrow.left").font(.system(size: 40))
                    } else {
                        Text(numbers[index])
                    }
                })
                .lineLimit(1).minimumScaleFactor(0.5).font(.system(size: fontSize)).foregroundColor(color)
                .frame(width: UIScreen.main.bounds.width/4)
            })
        }
    }
}

// MARK: - Render preview UI
struct CustomNumberInputView_Previews: PreviewProvider {
    static var previews: some View {
        CustomNumberInputViewPreview()
    }
}

struct CustomNumberInputViewPreview: View {
    @State var amount: Int = 1
    var body: some View {
        CustomNumberInputView(amount: $amount)
    }
}
