import Core
import SwiftUI

struct AppsAPIError: View {
    let error: Binding<Applications.Error?>
    let action: () -> Void

    var body: some View {
        switch error.wrappedValue {
        case .noInternet: AppsNoInternetView(retry: retry)
        case .unknownSDK: AppsNotCompatibleFirmware()
        default: EmptyView()
        }
    }

    func retry() {
        error.wrappedValue = nil
        action()
    }
}
