//
//  AppDelegate.swift
//  Uncarbon
//
//  Created by Bracken Dawson on 06/09/2022.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.title = "Uncarbon"
        }
        
        let menu = NSMenu()
        
        let status = NSMenuItem()
        status.title = "On grid"
        menu.addItem(status)
        menu.addItem(NSMenuItem.separator())
        
        let cont = NSMenuItem(title: "Disable until tomorrow", action: #selector(toggleEnabled), keyEquivalent: "")
        menu.addItem(cont)
        
        let pref = NSMenuItem(title: "Preferences...", action: #selector(showPrefs), keyEquivalent: ",")
        menu.addItem(pref)
        
        let quit = NSMenuItem(title: "Quit Uncarbon", action: #selector(NSApplication.shared.terminate(_:)), keyEquivalent: "q")
        menu.addItem(quit)
        
        statusItem.menu = menu
    }
    
    @objc func showPrefs() { // don't throws here after getting rid of remote creation
        print("would show prefs")

        // TODO don't install the helper here
        
        // TODO probably in constructor
                
        let remote: HelperProtocol?
        do {
            remote = try HelperRemote().getRemote()
        } catch {
            print("TODO: \(error)")
            return
        }

        print("got remote")

        remote?.setMode(mode: Mode.save) { (mode, err) in print(mode == Mode.save, err?.localizedDescription ?? "success") } // TODO send the error somewhere
        
        print("did thing")
    }

    @objc func toggleEnabled() {
        print("would toggle")
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

