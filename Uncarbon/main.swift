//
//  main.swift
//  Uncarbon
//
//  Created by Bracken Dawson on 06/09/2022.
//

import AppKit

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate

_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
