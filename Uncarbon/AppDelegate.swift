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
        
        let cont = NSMenuItem(title: "Disable for today", action: #selector(toggleEnabled), keyEquivalent: "d")
        menu.addItem(cont)
        
        let pref = NSMenuItem(title: "Preferences...", action: #selector(showPrefs), keyEquivalent: ",")
        menu.addItem(pref)
        
        let quit = NSMenuItem(title: "Quit Uncarbon", action: #selector(NSApplication.shared.terminate(_:)), keyEquivalent: "q")
        menu.addItem(quit)
        
        statusItem.menu = menu
    }
    
    @objc func showPrefs() {
        print("would show prefs")
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

