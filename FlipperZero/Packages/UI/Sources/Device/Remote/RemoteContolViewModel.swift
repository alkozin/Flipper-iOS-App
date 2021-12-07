import Core
import Combine
import Foundation

// FIXME:
// @MainActor
class RemoteContolViewModel: ObservableObject {
    @Published var frame: ScreenFrame = .init()

    let rpc: RPC = .shared

    init() {
        rpc.onScreenFrame = self.onScreenFrame
    }

    func startStreaming() {
        print("startStreaming")
        Task {
            try await rpc.startStreaming()
        }
    }

    func stopStreaming() {
        print("stopStreaming")
        Task {
            try await rpc.stopStreaming()
        }
    }

    func onScreenFrame(_ frame: ScreenFrame) {
        self.frame = frame
    }

    func onButton(_ button: InputKey) {
        feedback()
        Task {
            try await rpc.pressButton(button)
        }
    }
}

import SwiftUI

func feedback() {
    let impactMed = UIImpactFeedbackGenerator(style: .medium)
    impactMed.impactOccurred()
}