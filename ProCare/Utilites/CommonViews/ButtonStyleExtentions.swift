//
//  ButtonStyleExtentions.swift
//  CustomButton
//
//  Created by ahmed hussien on 27/01/2025.
//

import SwiftUI

enum CustomButtonKind {
    case solid
    case border
    case plain
}

struct AppButton: ButtonStyle {
    let kind: CustomButtonKind
    let width: CGFloat?
    let height: CGFloat?
    let disabled: Bool
    let isLoading: Bool
    let backgroundColor: Color
    
    init(
        kind: CustomButtonKind = .solid,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        disabled: Bool = false,
        isLoading: Bool = false,
        backgroundColor: Color = .appPrimary
    ) {
        self.kind = kind
        self.width = width
        self.height = height
        self.disabled = disabled
        self.isLoading = isLoading
        self.backgroundColor = backgroundColor
    }

    func makeBody(configuration: Configuration) -> some View {
        let isPressed = configuration.isPressed
        return ZStack {
            if isLoading {
              ProgressView()
                    .appProgressStyle(color: foregroundColor)
            } else {
                configuration.label
            }
        }
        .padding()
        .frame(height: height)
        .frame(maxWidth: width ?? .infinity)
        .foregroundColor(foregroundColor)
        .background(background(isPressed: isPressed, color: backgroundColor))
        .padding(.horizontal, 5)
        .opacity(disabled ? 0.6 : 1.0)
    }

    private var foregroundColor: Color {
        switch kind {
        case .solid:
            return .white
        case .border:
            return disabled ? .gray.opacity(0.8) : backgroundColor
        case .plain:
            return disabled ? .gray.opacity(0.8) : .black
        }
    }

    @ViewBuilder
    private func background(isPressed: Bool, color: Color) -> some View {
        switch kind {
        case .solid:
            RoundedRectangle(cornerRadius: 30)
                .fill(disabled ? Color.gray : (isPressed ? color.opacity(0.7) : color))
        case .border:
            RoundedRectangle(cornerRadius: 30)
                .stroke(disabled ? .gray.opacity(0.8) : color, lineWidth: 1)
        case .plain:
            Color.clear
        }
    }
    
    // MARK: - Circular Loader View
    struct CircularLoaderView: View {
        var strokeWidth: CGFloat = 2.0
        var tintColor: Color = .white
        var duration: TimeInterval = 1.0 // seconds for a full rotation

        var body: some View {
            TimelineView(.animation) { timeline in
                let now = timeline.date.timeIntervalSinceReferenceDate
                // Compute a 0...360 rotation based on time and duration
                let progress = (now.truncatingRemainder(dividingBy: duration)) / duration
                let angle = Angle(degrees: progress * 360)

                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(tintColor, style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round, lineJoin: .round))
                    .rotationEffect(angle)
            }
        }
    }
}

extension View {
    func appButtonStyle(
        _ kind: CustomButtonKind = .solid,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        disabled: Bool = false,
        isLoading: Bool = false,
        backgroundColor: Color = .appPrimary
    ) -> some View {
        self.buttonStyle(AppButton(
            kind:  kind,
            width: width,
            height: height,
            disabled: disabled ,
            isLoading: isLoading,
            backgroundColor: backgroundColor
        ))
        .disabled(disabled || isLoading)
    }
}

// MARK: - Preview
#Preview {
    PreviewContainer()
}

// MARK: - Preview Container
struct PreviewContainer: View {
    @State private var isLoading = false
    @State private var isDisabled = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // MARK: - Interactive Controls
                VStack(spacing: 16) {
                    Text("Interactive Controls")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        Toggle("Loading", isOn: $isLoading)
                        Toggle("Disabled", isOn: $isDisabled)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                }
                
                Divider()
                
                // MARK: - Solid Buttons
                Group {
                    Text("Solid Buttons")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button("Interactive Button") {}
                        .appButtonStyle(.solid, disabled: isDisabled, isLoading: isLoading)
//                        .buttonStyle(AppButton(kind: .solid, disabled: isDisabled, isLoading: isLoading))
                    
                    Button("Custom Color") {}
                        .buttonStyle(AppButton(kind: .solid, disabled: isDisabled, isLoading: isLoading, backgroundColor: .green))
                    
                    Button("Custom Height") {}
                        .buttonStyle(AppButton(kind: .solid, height: 100, disabled: isDisabled, isLoading: isLoading))
                }
                
                Divider()
                
                // MARK: - Border Buttons
                Group {
                    Text("Border Buttons")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button("Interactive Button") {}
                        .buttonStyle(AppButton(kind: .border, disabled: isDisabled, isLoading: isLoading))
                    
                    Button("Custom Color") {}
                        .buttonStyle(AppButton(kind: .border, disabled: isDisabled, isLoading: isLoading, backgroundColor: .orange))
                    
                    Button("Custom Height") {}
                        .buttonStyle(AppButton(kind: .border, height: 100, disabled: isDisabled, isLoading: isLoading))
                }
                
                Divider()
                
                // MARK: - Plain Buttons
                Group {
                    Text("Plain Buttons")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button("plain") {}
                        .buttonStyle(AppButton(kind: .plain, disabled: isDisabled, isLoading: isLoading))
                }
                
                Divider()
                
                // MARK: - Static Examples
                Group {
                    Text("Static Examples")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button("Normal State") {}
                        .buttonStyle(AppButton(kind: .solid))
                    
                    Button("Loading State") {}
                        .buttonStyle(AppButton(kind: .solid, isLoading: true))
                    
                    Button("Disabled State") {}
                        .buttonStyle(AppButton(kind: .solid, disabled: true))
                }
                
                Divider()
                
                // MARK: - Real-World Examples
                Group {
                    Text("Real-World Examples")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button("Sign In") {}
                        .buttonStyle(AppButton(kind: .solid, height: 50, disabled: isDisabled, isLoading: isLoading, backgroundColor: .blue))
                    
                    Button("Create Account") {}
                        .buttonStyle(AppButton(kind: .border, height: 50, disabled: isDisabled, isLoading: isLoading, backgroundColor: .blue))
                    
                    Button("Skip for now") {}
                        .buttonStyle(AppButton(kind: .plain, disabled: isDisabled, isLoading: isLoading))
                    
                    Button("Submit") {}
                        .buttonStyle(AppButton(kind: .solid, height: 50, disabled: isDisabled, isLoading: isLoading, backgroundColor: .green))
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
    }
}
