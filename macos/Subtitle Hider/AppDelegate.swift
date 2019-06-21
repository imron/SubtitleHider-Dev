//
//  AppDelegate.swift
//  Subtitle Hider
//
//  Created by Imron Alston on 2019/6/20.
//  Copyright © 2019 Imral Software Pty Ltd. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application

        window.level = .floating
        window.collectionBehavior = [.canJoinAllSpaces]
        window.delegate = window.contentView as? MainView
        window.isMovableByWindowBackground = true

        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("statusbar"))
        }

        let menu = NSMenu()
        menu.addItem(withTitle: "Quit", action: #selector( onQuit ), keyEquivalent: "q" )
        statusItem.menu = menu
    }

    @objc func onQuit( sender: Any ) {
        NSApp.terminate( self )
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    

}

