//
//  ChartView.swift
//  Trading Lemon
//
//  Created by Kevin Chromik on 31.05.22.


import SwiftUI

/// Shows the stock chart
struct ChartView: View {

    private let chartWidth: CGFloat = UIScreen.main.bounds.width
    var chartHeight: CGFloat = 160
    var data: [Double]

    // MARK: - Main rendering function
    var body: some View {
        let chartPoints = data.count - 1
        let highLowPoint = CGPoint(x: chartWidth / CGFloat(chartPoints), y: chartHeight / max(0.1, CGFloat((data.max() ?? 0.0) - (data.min() ?? 0.0))))
        return ZStack {
            /// Use this as a closed path for the background gradient for the chart
            Path.chart(withPoints: data, highLowPoint: highLowPoint, closePath: true)
                .fill(LinearGradient(gradient: Gradient(colors: [AppConfig.lightBackground.opacity(0.1), mainColor.opacity(0.75)]), startPoint: .top, endPoint: .bottom))

            /// Use this as the main chart line
            Path.chart(withPoints: data, highLowPoint: highLowPoint, closePath: false)
                .stroke(mainColor, style: StrokeStyle(lineWidth: 3, lineJoin: .round))
        }
        .rotationEffect(.degrees(180), anchor: .center)
        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
        .frame(width: chartWidth, height: chartHeight)
    }

    /// Chart color
    private var mainColor: Color {
        data[data.count - 1] >= data[0] ? AppConfig.positiveColor : AppConfig.negativeColor
    }
}

// MARK: - Render preview UI
struct ChartView_Preview: PreviewProvider {
    static var previews: some View {
        ChartView(data: [])
    }
}
