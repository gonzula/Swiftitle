//
//  AppDelegate.swift
//  Swiftitle
//
//  Created by Gonzo Fialho on 12/01/18.
//  Copyright © 2018 Gonzo Fialho. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

extension URL {
    var typeIdentifier: String? {
        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }

    var localizedName: String? {
        return (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName
    }

    func UTIConformsTo(_ type: CFString) -> Bool {
        return UTTypeConformsTo(typeIdentifier! as CFString, type)
    }
}
extension FileManager {
    func isDirectory(_ url: URL) -> Bool? {
        var isDirectory: ObjCBool = false
        let fm = FileManager.default
        if fm.fileExists(atPath: url.path, isDirectory: &isDirectory) {
            return isDirectory.boolValue
        }

        return nil
    }
}
