//
//  Helpers.swift
//  Trading Lemon
//
//  Created by Kevin Chromik on 20.05.22.
//

import SwiftUI
import CoreGraphics

extension Float {
    var dollarAmount: String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.current
        return currencyFormatter.string(from: NSNumber(value: self)) ?? "- -"
    }

    func rounded(toPlaces places: Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }

    func formattedAmount(with locale: String) -> String {
        let loc: Locale = locale == "EUR" ? Locale(identifier: "de_DE") : Locale(identifier: "en_US")
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency

        currencyFormatter.locale = loc
        return currencyFormatter.string(from: NSNumber(value: self)) ?? "- -"
    }

    func getSymbol(forCurrencyCode code: String) -> String? {
        let locale = NSLocale(localeIdentifier: code)
        if locale.displayName(forKey: .currencySymbol, value: code) == code {
            let newlocale = NSLocale(localeIdentifier: code.dropLast() + "_en")
            return newlocale.displayName(forKey: .currencySymbol, value: code)
        }
        return locale.displayName(forKey: .currencySymbol, value: code)
    }
}

/// Create a shape with specific rounded corners
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension Path {
    static func chart(withPoints points: [Double], highLowPoint: CGPoint, closePath: Bool) -> Path {
        var path = Path()
        if closePath { path.move(to: .zero) }
        var p1 = CGPoint(x: 0, y: CGFloat(points[0]-points.min()!)*highLowPoint.y)
        if closePath { path.addLine(to: p1) } else { path.move(to: p1) }
        for pointIndex in 1..<points.count {
            let p2 = CGPoint(x: highLowPoint.x * CGFloat(pointIndex), y: highLowPoint.y*CGFloat(points[pointIndex]-points.min()!))
            let midPoint = CGPoint.midPointForPoints(p1: p1, p2: p2)
            path.addQuadCurve(to: midPoint, control: CGPoint.controlPointForPoints(p1: midPoint, p2: p1))
            path.addQuadCurve(to: p2, control: CGPoint.controlPointForPoints(p1: midPoint, p2: p2))
            p1 = p2
        }
        if closePath {
            path.addLine(to: CGPoint(x: p1.x, y: 0))
            path.closeSubpath()
        }
        return path
    }
}

extension CGPoint {
    static func midPointForPoints(p1:CGPoint, p2:CGPoint) -> CGPoint {
        return CGPoint(x:(p1.x + p2.x) / 2,y: (p1.y + p2.y) / 2)
    }

    static func controlPointForPoints(p1:CGPoint, p2:CGPoint) -> CGPoint {
        var controlPoint = CGPoint.midPointForPoints(p1:p1, p2:p2)
        let diffY = abs(p2.y - controlPoint.y)
        if (p1.y < p2.y) {
            controlPoint.y += diffY
        } else if (p1.y > p2.y) {
            controlPoint.y -= diffY
        }
        return controlPoint
    }
}

extension Date {

    var formatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
