//
//  MainView.swift
//  Subtitle Hider
//
//  Created by Imron Alston on 2019/6/20.
//  Copyright © 2019 Imral Software Pty Ltd. All rights reserved.
//

import Cocoa

class MainView: NSView, NSWindowDelegate {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        NSColor.black.setFill()
        dirtyRect.fill()
    }

    func setAlpha( value: CGFloat ) {
        guard let window = window else {
            return
        }
        window.alphaValue = value
    }

    override func mouseDown(with event: NSEvent) {
        setAlpha( value: 0.5 )
    }

    override func mouseUp(with event: NSEvent) {
        setAlpha( value: 1.0 )
    }

    func windowWillStartLiveResize(_ notification: Notification) {
        setAlpha( value:0.5 )
    }

    func windowDidEndLiveResize(_ notification: Notification) {
        setAlpha( value: 1.0 )
    }

}
