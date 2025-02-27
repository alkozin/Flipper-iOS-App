import Core
import SwiftUI

struct InfraredEmulateView: View {
    @EnvironmentObject var device: Device
    @EnvironmentObject var emulate: Emulate

    @State var currentEmulateIndex: Int?

    let item: ArchiveItem
    let names: [String]

    init(item: ArchiveItem) {
        self.item = item
        self.names = item.infraredSignalNames
    }

    enum InfraredEmulateStatus {
        case disconnected
        case synchronizing
        case notSupported
        case canEmulate(Bool)
    }

    var state: InfraredEmulateStatus {
        if device.status == .disconnected {
            return .disconnected
        }

        if device.status == .connecting || device.status == .synchronizing {
            return .synchronizing
        }

        if let flipper = device.flipper, !flipper.hasInfraredEmulateSupport {
            return .notSupported
        }
        return .canEmulate(item.status == .synchronized)
    }

    var isEmptySignals: Bool {
        names.isEmpty
    }

    var body: some View {
        switch state {
        case .disconnected:
            notSupportEmulateView()
            EmulateSupportView(text: "Flipper not connected")
                .padding(.bottom, isEmptySignals ? 0 : 4)
        case .notSupported:
            notSupportEmulateView()
            EmulateSupportView(text: "Update firmware to use this feature")
                .padding(.bottom, isEmptySignals ? 0 : 4)
        case .synchronizing:
            if isEmptySignals {
                ConnectingButton()
            } else {
                VStack(alignment: .center, spacing: 12.0) {
                    ForEach(0 ..< names.count, id: \.self) { _ in
                        ConnectingButton()
                    }
                }
            }
        case .canEmulate(let synchronized):
            if isEmptySignals {
                EmulateEmptyView()
            } else {
                VStack(alignment: .center, spacing: 12.0) {
                    ForEach(0 ..< names.count, id: \.self) { index in
                        infraredRemoteView(index: index)
                            .disabled(!synchronized)
                    }
                }
                .onChange(of: emulate.state) { state in
                    if state == .closed || state == .locked {
                        currentEmulateIndex = nil
                    }
                }
                .onChange(of: device.status) { status in
                    if status == .disconnected {
                        currentEmulateIndex = nil
                    }
                }
            }
        }
    }

    struct EmulateSupportView: View {
        let text: String

        var body: some View {
            HStack(spacing: 4) {
                Image("WarningSmall")
                Text(text)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.black20)
            }
            .frame(maxWidth: .infinity)
        }
    }

    struct EmulateEmptyView: View {
        var body: some View {
            Text("No buttons saved for this remote yet.\n" +
                 "Use your Flipper Zero to add some."
            )
            .multilineTextAlignment(.center)
            .font(.system(size: 11, weight: .medium))
            .foregroundColor(.black20)
            .frame(maxWidth: .infinity)
        }
    }

    @ViewBuilder private func infraredRemoteView(index: Int) -> some View {
        InfraredButton(
            text: names[index],
            isEmulating: currentEmulateIndex == index,
            emulateDuration: item.duration,
            onTap: { processTapEmulate(index: index) },
            onPressed: { processStartEmulate(index: index) },
            onReleased: stopEmulate
        )
    }

    @ViewBuilder private func notSupportEmulateView() -> some View {
        VStack(alignment: .center, spacing: 12.0) {
            if names.count > 3 {
                infraredRemoteView(index: 0)
                infraredRemoteView(index: 1)
                HStack(alignment: .center) {
                    Text(names[2])
                        .font(.born2bSportyV2(size: 23))
                }
                .frame(height: 48)
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.emulateDisabled, .clear]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                ForEach(0 ..< names.count, id: \.self) { index in
                    infraredRemoteView(index: index)
                }
            }
        }
        .disabled(true)
    }

    func processStartEmulate(index: Int) {
        if currentEmulateIndex == index {
            forceStopEmulate()
        } else {
            currentEmulateIndex = index
            emulate.startEmulate(item, .infrared(index: index))
        }
    }

    func processTapEmulate(index: Int) {
        if currentEmulateIndex == index {
            forceStopEmulate()
        } else {
            guard let flipper = device.flipper else { return }
            currentEmulateIndex = index

            if flipper.hasSingleEmulateSupport {
                emulate.startEmulate(item, .infraredSingle(index: index))
            } else {
                emulate.startEmulate(item, .infrared(index: index))
                stopEmulate()
            }
        }
    }

    func stopEmulate() {
        guard currentEmulateIndex != nil else { return }
        emulate.stopEmulate()
    }

    func forceStopEmulate() {
        guard currentEmulateIndex != nil else { return }
        emulate.forceStopEmulate()
    }
}

extension Flipper {
    var hasInfraredEmulateSupport: Bool {
        guard
            let protobuf = information?.protobufRevision,
            protobuf >= .v0_21
        else {
            return false
        }
        return true
    }

    var hasSingleEmulateSupport: Bool {
        guard
            let protobuf = information?.protobufRevision,
            protobuf >= .v0_25
        else {
            return false
        }
        return true
    }
}
