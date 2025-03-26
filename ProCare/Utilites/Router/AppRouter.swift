//
//  Router.swift
//  AllinOnApp
//
//  Created by ahmed hussien on 19/03/2025.
//

import Foundation
import SwiftUI

protocol RouterProtocol: ObservableObject {
    var path: NavigationPath { get set }
    var sheetView: SheetView? { get set }
    var fullScreen: FullScreen? { get set }

    func push(_ screen:  Screen)
    func presentSheet(_ sheet: SheetView)
    func presentFullScreenCover(_ fullScreenCover: FullScreen)
    func pop()
    func popToRoot()
    func dismissSheet()
    func dismissFullScreenOver()
}


class AppRouter : RouterProtocol {
    @Published var path: NavigationPath = NavigationPath()
    @Published var sheetView: SheetView?
    @Published var fullScreen: FullScreen?
    
    func push(_ screen: Screen) {
        path.append(screen)
    }
    
    func pushView<V: View>(_ view: V) {
        let container = AnyViewContainer(view: AnyView(view))
        path.append(container)
    }
    
    func presentSheet(_ sheet: SheetView) {
        self.sheetView = sheet
    }
    
    func presentFullScreenCover(_ fullScreen: FullScreen) {
        self.fullScreen = fullScreen
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func dismissSheet() {
        self.sheetView = nil
    }
    
    func dismissFullScreenOver() {
        self.fullScreen = nil
    }
    
    
    // MARK: - Presentation Style Providers
    @ViewBuilder
    func build(_ screen: Screen) -> some View {
        switch screen {
        case.tapbar:
            TapBarView()
        }
    }
    
    @ViewBuilder
    func build(_ sheet: SheetView) -> some View {
        switch sheet {
        case .detailTask:
           Text("empty sheet")
        }
    }
    
    @ViewBuilder
    func build(_ fullScreenCover: FullScreen) -> some View {
        switch fullScreenCover {
        case .addHabit:
            Text("empty fullScreenCover")
        }
    }

}
