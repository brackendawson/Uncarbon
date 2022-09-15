//
//  Helper.swift
//  cc.bracken.Uncarbon.Helper
//
//  Created by Bracken Dawson on 07/09/2022.
//

import Foundation

class Helper: NSObject, NSXPCListenerDelegate, HelperProtocol {
    let listener: NSXPCListener
    
    override init() {
        self.listener = NSXPCListener(machServiceName: HelperConstants.domain)
        super.init()
        self.listener.delegate = self
    }
    
    // TODO probably the callback should pass back the mode set when sucessful
    func setMode(mode: Mode, then: @escaping (Mode, Error?) -> Void) {
        print("would set mode \(mode)")
        then(mode, nil)
    }
    
    func run() {
        self.listener.resume()
        RunLoop.current.run()
    }
    
    func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
        newConnection.exportedInterface = NSXPCInterface(with: HelperProtocol.self)
        newConnection.remoteObjectInterface = NSXPCInterface(with: RemoteApplicationProtocol.self)
        newConnection.exportedObject = self
        newConnection.resume()
        return true
    }
}
