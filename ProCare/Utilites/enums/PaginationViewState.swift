//
//  PaginationViewState.swift
//  ProCare
//
//  Created by ahmed hussien on 01/05/2025.
//


enum PaginationViewState: Equatable  {
    case initialLoading
    case pagingLoading
    case refreshing
    case loaded
    case empty
    case error(String)
}

enum LoadType {
    case initial
    case paging
    case refresh
}