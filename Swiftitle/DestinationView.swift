//
//  DestinationView.swift
//  Swiftitle
//
//  Created by Gonzo Fialho on 13/01/18.
//  Copyright © 2018 Gonzo Fialho. All rights reserved.
//

import Cocoa

protocol DestinationViewDelegate {
    func droppedURLS(_ urls: [URL])
}

class DestinationView: NSView {

    enum Appearance {
        static let lineWidth: CGFloat = 10.0
    }

    var delegate: DestinationViewDelegate?

    let filteringOptions: [NSPasteboard.ReadingOptionKey : Any] = [.urlReadingContentsConformToTypes: ["public.movie", "public.folder"],
                                                                .urlReadingFileURLsOnly: true]

    var isReceivingDrag = false {
        didSet {
            needsDisplay = true
        }
    }

    override func awakeFromNib() {
        setup()
    }

    func setup() {
        registerForDraggedTypes([kUTTypeFileURL as NSPasteboard.PasteboardType])
    }

    func shouldAllowDrag(_ draggingInfo: NSDraggingInfo) -> Bool {

        var canAccept = false

        let pasteBoard = draggingInfo.draggingPasteboard()

        if pasteBoard.canReadObject(forClasses: [NSURL.self], options: filteringOptions) {
            canAccept = true
        }
        return canAccept
    }

    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        let allow = shouldAllowDrag(sender)
        isReceivingDrag = allow
        return allow ? .generic : NSDragOperation()
    }

    override func draggingExited(_ sender: NSDraggingInfo?) {
        isReceivingDrag = false
    }

    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        let allow = shouldAllowDrag(sender)
        return allow
    }

    override func performDragOperation(_ draggingInfo: NSDraggingInfo) -> Bool {

        isReceivingDrag = false
        let pasteBoard = draggingInfo.draggingPasteboard()

        if let urls = pasteBoard.readObjects(forClasses: [NSURL.self], options:filteringOptions) as? [URL], urls.count > 0 {
            delegate?.droppedURLS(urls)
            return true
        }
        return false

    }

    override func draw(_ dirtyRect: NSRect) {

        if isReceivingDrag {
            NSColor.selectedControlColor.set()

            let path = NSBezierPath(rect:bounds)
            path.lineWidth = Appearance.lineWidth
            path.stroke()
        }
    }

    override func hitTest(_ aPoint: NSPoint) -> NSView? {
        return nil
    }

}
