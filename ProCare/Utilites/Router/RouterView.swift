//
//  RouterView.swift
//  AllinOnApp
//
//  Created by ahmed hussien on 19/03/2025.
//

import SwiftUI

struct RouterView: View {
    @EnvironmentObject var appRouter: AppRouter
    var body: some View {
        NavigationStack(path: $appRouter.path) {
            appRouter.build(.RootScreen)
                .navigationDestination(for: Screen.self) { screen in
                    appRouter.build(screen)
                }
                .sheet(item: $appRouter.sheetView) { sheet in
                    appRouter.build(sheet)
                }
                .fullScreenCover(item: $appRouter.fullScreen) { fullScreen in
                    appRouter.build(fullScreen)
                }
                .navigationDestination(for: AnyViewContainer.self) { container in
                    container.view
                }
        }
    }
}

#Preview {
    RouterView()
}
