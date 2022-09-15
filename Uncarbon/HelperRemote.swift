//
//  HelperRemote.swift
//  Uncarbon
//
//  Created by Bracken Dawson on 08/09/2022.
//

import Foundation
import XPC
import ServiceManagement

struct HelperRemote {
    // TODO this needs some sort of version check
    var isHelperInstalled: Bool { FileManager.default.fileExists(atPath: HelperConstants.helperPath) }
    
    private func installHelper() throws {
        var authRef: AuthorizationRef?
        var authStatus = AuthorizationCreate(nil, nil, [.preAuthorize], &authRef)
        guard authStatus == errAuthorizationSuccess else {
            throw UncarbonError.helperInstallation("unable to get a valid empty authorization reference to load Helper daemon: : \(SecCopyErrorMessageString(authStatus, nil)!)")
        }
        
        let authItem = kSMRightBlessPrivilegedHelper.withCString { authorizationString in
            AuthorizationItem(name: authorizationString, valueLength: 0, value: nil, flags: 0)
        }
        
        let authItemPtr = UnsafeMutablePointer<AuthorizationItem>.allocate(capacity: 1)
        authItemPtr.initialize(to: authItem)
        defer {
            authItemPtr.deinitialize(count: 1)
            authItemPtr.deallocate()
        }
        
        var authRights = AuthorizationRights(count: 1, items: authItemPtr)
        
        // TODO are these the right rights?
        let authFlags: AuthorizationFlags = [.interactionAllowed, .extendRights, .preAuthorize]
        authStatus = AuthorizationCreate(&authRights, nil, authFlags, &authRef)
        guard authStatus == errAuthorizationSuccess else {
            throw UncarbonError.helperInstallation("unable to get a valid loading authorization reference to load Helper daemon: \(SecCopyErrorMessageString(authStatus, nil)!)")
        }
        
        var err: Unmanaged<CFError>?
        if SMJobBless(kSMDomainUserLaunchd, HelperConstants.domain as CFString, authRef, &err) == false {
            let blessError = err!.takeRetainedValue() as Error
            throw UncarbonError.helperInstallation("error while installing the helper: \(blessError.localizedDescription)")
        }
        
        AuthorizationFree(authRef!, [])
    }
    
    private func createConnection() -> NSXPCConnection {
        let connection = NSXPCConnection(machServiceName: HelperConstants.domain, options: .privileged)
        connection.remoteObjectInterface = NSXPCInterface(with: HelperProtocol.self)
        connection.exportedInterface = NSXPCInterface(with: RemoteApplicationProtocol.self)
        connection.exportedObject = self
        connection.invalidationHandler = { [isHelperInstalled] in
            if isHelperInstalled {
                print("Unable to connect to Helper although it is insalled")
            } else {
                print("Helper is not installed")
            }
        }
        connection.resume()
        return connection
    }
    
    private func getConnection() throws -> NSXPCConnection {
        if !isHelperInstalled {
            try installHelper()
        }
        return createConnection()
    }
    
    func getRemote() throws -> HelperProtocol {
        var proxyErr: Error?
        
        let helper = try getConnection().remoteObjectProxyWithErrorHandler({ (error) in
            proxyErr = error
        }) as? HelperProtocol
        
        if let unwrappedHelper = helper {
            return unwrappedHelper
        }
        throw UncarbonError.helperConnection(proxyErr?.localizedDescription ?? "unknown error")
    }
}
