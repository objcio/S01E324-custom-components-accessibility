import SwiftUI

struct CapsuleStepperStyle: MyStepperStyle {
    func makeBody(_ configuration: MyStepperStyleConfiguration) -> some View {
        CapsuleStepper(configuration: configuration)
    }
}

struct CapsuleStepper: View {
    var configuration: MyStepperStyleConfiguration
    
    @Environment(\.controlSize)
    var controlSize
    
    var padding: Double {
        switch controlSize {
        case .mini: return 4
        case .small: return 6
        default: return 8
        }
    }
    
    var body: some View {
        HStack {
            configuration.label
            Spacer()
            HStack {
                Button { configuration.value.wrappedValue -= 1 } label: {
                    Image(systemName: "minus")
                        .accessibilityLabel("Decrement")
                }
                Text(configuration.value.wrappedValue.formatted())
                Button { configuration.value.wrappedValue += 1 } label: {
                    Image(systemName: "plus")
                        .accessibilityLabel("Increment")
                }
            }
            .transformEnvironment(\.font, transform: { font in
                if font != nil { return }
                switch controlSize {
                case .mini: font = .footnote
                case .small: font = .callout
                default: font = .body
                }

            })
            .padding(.vertical, padding)
            .padding(.horizontal, padding * 2)
            .foregroundColor(.white)
            .background {
                Capsule()
                    .fill(.tint)
            }
        }
        .buttonStyle(.plain)
    }
}

