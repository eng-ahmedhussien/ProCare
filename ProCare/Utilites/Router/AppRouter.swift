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


class AppRouter: RouterProtocol {
    @Published var path: NavigationPath = NavigationPath()
    @Published var sheetView: SheetView?
    @Published var fullScreen: FullScreen?
    
    //MARK: - functions
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
        DispatchQueue.main.async { [weak self] in
            self?.path.removeLast(self?.path.count ?? 0)
        }
    }
   
    
    func dismissSheet() {
        self.sheetView = nil
    }
    
    func dismissFullScreenOver() {
        self.fullScreen = nil
    }
}

