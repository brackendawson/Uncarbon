//
//  HelperProtocol.swift
//  Uncarbon
//
//  Created by Bracken Dawson on 07/09/2022.
//

import Foundation

enum HelperConstants {
    static let helpersDir = "/Library/PrivilegedHelperTools/"
    static let domain = "cc.bracken.Uncarbon.Helper"
    static let helperPath = helpersDir + domain
}

@objc public enum Mode: Int {
    case reset // on-grid, charging enabled
    case save  // off-grid, charging enabled but impossible
    case hold  // on-grid, charging disabled
    case unknown // used as a zero value for errors
}

@objc(HelperProtocol)
public protocol HelperProtocol {
    @objc func setMode(mode: Mode, then: @escaping (Mode, Error?) -> Void)
}
