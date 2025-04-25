//
//  SproutApp.swift
//  Sprout
//
//  Created by Samuel Wu (student LM) on 2/13/25.
//

import SwiftUI
import FirebaseCore

@main
struct SproutApp: App {
    @StateObject private var authViewModel: AuthViewModel
    @StateObject private var userViewModel: UserViewModel
    @StateObject private var healthViewModel: HealthViewModel

    init() {
        FirebaseApp.configure()
        let authVM = AuthViewModel()
        _authViewModel = StateObject(wrappedValue: authVM)

        let userVM = UserViewModel(authVM: authVM)
        _userViewModel = StateObject(wrappedValue: userVM)

        let healthVM = HealthViewModel(authVM: authVM, userVM: userVM)
        _healthViewModel = StateObject(wrappedValue: healthVM)
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authViewModel)
                .environmentObject(userViewModel)
                .environmentObject(healthViewModel)
        }
    }
}

import SwiftUI

struct RootView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var userViewModel: UserViewModel

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()
            if authViewModel.userSession == nil {
                LoginView()
            } else {
                HomeView()
                    .onAppear {
                        userViewModel.fetchUserProfile { exists in
                            if !exists,
                               let email = authViewModel.userSession?.email {
                                userViewModel.createDefaultUserProfile(email: email)
                            }
                        }
                    }
            }
        }
    }
}

extension UIImage {
    func trimmingTransparentPixels() -> UIImage {
        guard let cg = cgImage,
              let data = cg.dataProvider?.data,
              let ptr = CFDataGetBytePtr(data)
        else { return self }

        let w = cg.width, h = cg.height
        let bpp = cg.bitsPerPixel / 8
        let rowBytes = cg.bytesPerRow

        var minX = w, minY = h, maxX = 0, maxY = 0

        for y in 0..<h {
            for x in 0..<w {
                let alpha = ptr[y*rowBytes + x*bpp + (bpp-1)]
                if alpha > 0 {
                    minX = min(minX, x)
                    minY = min(minY, y)
                    maxX = max(maxX, x)
                    maxY = max(maxY, y)
                }
            }
        }

        let cropWidth = maxX - minX + 1
        let cropHeight = maxY - minY + 1

        guard cropWidth > 0, cropHeight > 0,
              let cropped = cg.cropping(to: CGRect(x: minX,
                                                   y: minY,
                                                   width: cropWidth,
                                                   height: cropHeight))
        else {
            return self
        }

        return UIImage(cgImage: cropped, scale: scale, orientation: imageOrientation)
    }
}
