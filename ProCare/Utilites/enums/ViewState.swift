//
//  ViewState.swift
//  ProCare
//
//  Created by ahmed hussien on 06/04/2025.
//

import Foundation


/// Represents the current state of the view
enum ViewState {
    case empty
    case loading
    case loaded
//    case error(HomeError)
//    
//    static func == (lhs: ViewState, rhs: ViewState) -> Bool {
//        switch (lhs, rhs) {
//        case (.empty, .empty):
//            return true
//        case (.loading, .loading):
//            return true
//        case (.loaded, .loaded):
//            return true
//        case (.error(let lhsError), .error(let rhsError)):
//            return lhsError.localizedDescription == rhsError.localizedDescription
//        default:
//            return false
//        }
//    }
}
