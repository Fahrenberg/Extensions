//
//  ColorScheme+Extension.swift
//  RuKa
//
//  Created by Jean-Nicolas on 11.07.22.
//

import SwiftUI
//
extension ColorScheme  {
    public var description: String {
        return self == .light ? "Light" : "Dark"
    }
}


@available(macOS 11.0, *)
struct PreviewAllColorScheme<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: @escaping () -> Content) {
        
        self.content = content()
    }
    
    var body: some View {
        ForEach(ColorScheme.allCases, id:\.self) { mode in
        content
            .padding()
                .previewLayout(PreviewLayout.sizeThatFits)
                .preferredColorScheme(mode)
                .previewDisplayName(mode.description)
        }
    }
}
