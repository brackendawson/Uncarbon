//
//  UncarbonError.swift
//  Uncarbon
//
//  Created by Bracken Dawson on 14/09/2022.
//

import Foundation

enum UncarbonError: LocalizedError {
    case helperInstallation(String)
    case helperConnection(String)
    
    var errorDescription: String? {
        switch self {
        case .helperInstallation(let description): return "helper installation error: \(description)"
        case .helperConnection(let description): return "helper connection error: \(description)"
        }
    }
}
