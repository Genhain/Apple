//
//  View+Ext.swift
//  Apple
//
//  Created by Ben Fowler on 19/2/2025.
//

import SwiftUI

extension View {
    func centered(for centering: ViewCentering) -> some View {
        switch centering {
        case .vertical:
            return AnyView(modifier(VCenterModifier()))
        case .horizontal:
            return AnyView(modifier(HCenterModifier()))
        }
    }
}

enum ViewCentering {
    case vertical
    case horizontal
}

struct HCenterModifier: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            Spacer()
            content
            Spacer()
        }
    }
}

struct VCenterModifier: ViewModifier {
    func body(content: Content) -> some View {
        VStack {
            Spacer()
            content
            Spacer()
        }
    }
}
