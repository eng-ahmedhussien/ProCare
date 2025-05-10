//
//  DropdownOption.swift
//  ProCare
//
//  Created by ahmed hussien on 07/05/2025.
//

import Foundation

protocol DropdownOption: Identifiable, Hashable {
    var id: Int { get }
    var name: String { get }
}
