// --------------------------------------------------------------------------------------
// -------------------------   SwiftUI - Preview - Extensions -----------------------------
// --------------------------------------------------------------------------------------


import SwiftUI
//
extension ColorScheme  {
    public var description: String {
        return self == .light ? "Light" : "Dark"
    }
}


@available(macOS 11.0, *)

public struct PreviewAllColorScheme<Content: View>: View {
    /**
        Display Dark and Light Mode Previews as two previews

        Example:
        ````
        struct TemplateOption_Previews: PreviewProvider {
            static var previews: some View {
                PreviewAllColorScheme() {
                    TemplateOption(template: Template())
                }
            }
          }
        ````
    */
    public let content: Content
    public init(@ViewBuilder content: @escaping () -> Content) {
        
        self.content = content()
    }
    
   public var body: some View {
        ForEach(ColorScheme.allCases, id:\.self) { mode in
        content
            .padding()
                .previewLayout(PreviewLayout.sizeThatFits)
                .preferredColorScheme(mode)
                .previewDisplayName(mode.description)
        }
    }
}
