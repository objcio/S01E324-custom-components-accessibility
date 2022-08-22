import SwiftUI

struct OnHold: ViewModifier {
    var perform: () -> ()
    @State private var isPressed = false
    
    func step() async throws {
        perform()
        try await Task.sleep(nanoseconds: 500_000_000)
        while true {
            perform()
            try await Task.sleep(nanoseconds: 100_000_000)
        }
    }
    
    func body(content: Content) -> some View {
        content
            ._onButtonGesture { pressed in
                isPressed = pressed
            } perform: {
            }
            .task(id: isPressed) {
                guard isPressed else { return }
                do {
                    try await step()
                } catch {}
            }
    }
}

extension View {
    func onHold(_ perform: @escaping () -> ()) -> some View {
        modifier(OnHold(perform: perform))
    }
}

@available(iOS 16.0, *)
struct VerticalStepperStyle: MyStepperStyle {
    func makeBody(_ configuration: MyStepperStyleConfiguration) -> some View {
        LabeledContent {
            
            HStack {
                ZStack {
                    Text("99")
                        .hidden()
                    Text(configuration.value.wrappedValue.formatted())
                }
                .monospacedDigit()
                
                VStack(spacing: 0) {
                    Image(systemName: "chevron.up")
                        .padding(4)
                    Image(systemName: "chevron.down")
                        .padding(4)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 4)
            .background {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(.regularMaterial)
            }
            .overlay {
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(.clear)
                        .contentShape(Rectangle())
                        .onHold {
                            configuration.value.wrappedValue += 1
                        }
                    Rectangle()
                        .fill(.clear)
                        .contentShape(Rectangle())
                        .onHold {
                            configuration.value.wrappedValue -= 1
                        }
                }
            }

        } label: {
            configuration.label
        }
    }
}

@available(iOS 16.0, *)
private struct Preview: View {
    @State var value = 0
    
    var body: some View {
        MyStepper(value: $value, in: 0...999) {
            Text("Quantity")
        }
        .stepperStyle(VerticalStepperStyle())
    }
}

@available(iOS 16.0, *)
struct VerticalStepperStyle_Previews: PreviewProvider {
    static var previews: some View {
        Preview()
            .padding()
    }
}
