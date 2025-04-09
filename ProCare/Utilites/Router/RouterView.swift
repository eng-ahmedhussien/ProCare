//
//  RouterView.swift
//  AllinOnApp
//
//  Created by ahmed hussien on 19/03/2025.
//

import SwiftUI

struct RouterView: View {
    @StateObject var appRouter: AppRouter = AppRouter()
    
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
                .navigationTitle("appRouter")
        }
        .environmentObject(appRouter)
    }
}

#Preview {
    RouterView()
}
