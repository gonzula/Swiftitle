//
//  ViewController.swift
//  Swiftitle
//
//  Created by Gonzo Fialho on 12/01/18.
//  Copyright © 2018 Gonzo Fialho. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var destinationView: DestinationView! {
        didSet {
            destinationView.delegate = self
        }
    }

    @IBOutlet weak var label: NSTextField!

    var isGettingSubtitles = false

    private var moviesToSubtitle = [URL]() {
        didSet {
            guard !moviesToSubtitle.isEmpty else {
                label.stringValue = "Drag movie files here"
                return
            }

            label.stringValue = "Getting subtitle for \(moviesToSubtitle.first!.lastPathComponent)"
            if moviesToSubtitle.count > 1 {
                label.stringValue += ", \(moviesToSubtitle.count - 1) remaining"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func getSubtitles() {
        guard let url = moviesToSubtitle.first else {
            isGettingSubtitles = false
            return
        }

        isGettingSubtitles = true
        do {
            try Subtitler(filePath: url.path, language: "pt").addSubtitleToFile { (error) in
                self.moviesToSubtitle = Array(self.moviesToSubtitle.dropFirst())
                self.getSubtitles()
            }
        } catch {
            moviesToSubtitle = Array(moviesToSubtitle.dropFirst())
            getSubtitles()
        }
    }

    func getMovies(in urls: [URL]) -> [URL] {
        let fm = FileManager.default
        var filteredURLS = [URL]()

        for url in urls {
            do {
                guard let isDirectory = fm.isDirectory(url) else {
                    continue
                }

                if isDirectory {
                    let directoryList = try fm.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
                    filteredURLS.append(contentsOf: getMovies(in: directoryList))
                } else if url.UTIConformsTo(kUTTypeMovie) {
                    filteredURLS.append(url)
                }
            } catch {
                print(error)
            }
        }

        return filteredURLS
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

extension ViewController: DestinationViewDelegate {
    func droppedURLS(_ urls: [URL]) {
        let filteredUrls = getMovies(in: urls)
        moviesToSubtitle.append(contentsOf: filteredUrls)
        if !isGettingSubtitles {
            getSubtitles()
        }
        for url in getMovies(in: urls) {
            print(url)
        }
    }
}
