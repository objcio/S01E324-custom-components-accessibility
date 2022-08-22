//
//  MyStepper.swift
//  Stepper
//
//  Created by Chris Eidhof on 17.08.22.
//

import Foundation
import SwiftUI

struct MyStepperStyleConfiguration {
    var value: Binding<Int>
    var label: Label
    var range: ClosedRange<Int>
    
    struct Label: View {
        var underlyingLabel: AnyView
        
        var body: some View {
            underlyingLabel
        }
    }
}

protocol MyStepperStyle {
    associatedtype Body: View
    func makeBody(_ configuration: MyStepperStyleConfiguration) -> Body
}

struct DefaultStepperStyle: MyStepperStyle {
    func makeBody(_ configuration: MyStepperStyleConfiguration) -> some View {
        Stepper(value: configuration.value, in: configuration.range) {
            configuration.label
        }
    }
}

extension MyStepperStyle where Self == DefaultStepperStyle {
    static var defaultStyle: DefaultStepperStyle { return .init() }
}


struct MyStepper<Label: View>: View {
    @Binding var value: Int
    var `in`: ClosedRange<Int> // todo
    @ViewBuilder var label: Label
    @Environment(\.stepperStyle) var style
    
    var body: some View {
        AnyView(style.makeBody(.init(value: $value, label: .init(underlyingLabel: AnyView(label)), range: `in`)))
            .accessibilityElement(children: .ignore)
            .accessibilityRepresentation(representation: {
                label
            })
            .accessibilityValue(value.formatted())
            .accessibilityAdjustableAction({ direction in
                switch direction {
                case .decrement:
                    value -= 1
                case .increment:
                    value += 1
                }
            })
    }
}

struct StepperStyleKey: EnvironmentKey {
    static let defaultValue: any MyStepperStyle = DefaultStepperStyle()
}

extension EnvironmentValues {
    var stepperStyle: any MyStepperStyle {
        get { self[StepperStyleKey.self] }
        set { self[StepperStyleKey.self] = newValue }
    }
}

extension View {
    func stepperStyle(_ style: some MyStepperStyle) -> some View {
        environment(\.stepperStyle, style)
    }
}

struct MyStepper_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MyStepper(value: .constant(10), in: 0...100, label: { Text("Value") })
            MyStepper(value: .constant(10), in: 0...100, label: { Text("Value") })
                .controlSize(.mini)
            MyStepper(value: .constant(10), in: 0...100, label: { Text("Value") })
                .controlSize(.large)
                .font(.largeTitle)
                .stepperStyle(CapsuleStepperStyle())
        }.padding()
    }
}
