// Abstract: A View that manages display of relevant text hints.

import SwiftUI

struct Hint: View {
    
    @Binding var sharedData: SharedData
    
    private var isHintShown: Bool {
        sharedData.hint != .none
    }
    
    var body: some View {
        if sharedData.didMeasureScrollItem {
            if isHintShown {
                VStack(spacing: 16) {
                    Image(systemName: sharedData.hint.symbol)
                        .accessibilityHidden(true)
                        .symbolEffect(.bounce, options: .repeat(2))
                        .font(.system(size: 28, weight: .medium, design: .default))
                    Text(sharedData.hint.text)
                        .accessibilityIdentifier(ViewIdentifiers.hint.rawValue)
                        .font(.system(size: 18, weight: .medium, design: .default))
                }
                .frame(width: 300)
                .multilineTextAlignment(.center)
                .opacity(isHintShown ? 1.0 : 0.0)
                .offset(x: 0, y: -sharedData.getHintOffset())
                .onAppear {
                    switch sharedData.hint {
                    case .none:
                        return
                    case .firstTimeExperience:
                        resetHintAfter(seconds: GlobalProperties.fteDuration)
                    case .volumeOff:
                        resetHintAfter(seconds: 3)
                    default:
                        resetHintAfter(seconds: 2)
                    }
                }
            }
        }
    }
    
    // MARK: Methods
    
    private func resetHintAfter(seconds deadline: TimeInterval) {
        Task(priority: .userInitiated) {
            try await Task.sleep(until: .now + .seconds(deadline))
            withAnimation(Animations.hint) {
                sharedData.setHint(to: .none)
            }
        }
    }
}
