//
//  LoadingState.swift
//  ProCare
//
//  Created by ahmed hussien on 04/06/2025.
//
import Foundation

// MARK: - View State
enum ViewState: Equatable {
    case idle
    case loading
    case loaded
    case failed(String)
    
    static func == (lhs: ViewState, rhs: ViewState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.loading, .loading):
            return true
        case (.loaded, .loaded):
            return true
        case (.failed(let lhsMessage), .failed(let rhsMessage)):
            return lhsMessage == rhsMessage
        default:
            return false
        }
    }
}
