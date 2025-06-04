//
//  LoadingState.swift
//  ProCare
//
//  Created by ahmed hussien on 04/06/2025.
//
import Foundation

// MARK: - View State
enum LoadingState {
    case idle
    case loading
    case loaded
    case failed(String)
}
