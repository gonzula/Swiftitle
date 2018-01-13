//
//  Subtitler.swift
//  Swiftitle
//
//  Created by Gonzo Fialho on 12/01/18.
//  Copyright © 2018 Gonzo Fialho. All rights reserved.
//

import Cocoa

class Subtitler {

    enum SubtitlerError: Error {
        case remoteError
    }

    private var filePath: String
    private var language: String
    private var searchHash: String?

    private var completionHandler: ((Error?)->Void)?

    init(filePath: String, language: String) {
        self.filePath = filePath
        self.language = language
    }

    func addSubtitleToFile(completion: @escaping (Error?)->Void) throws {
        completionHandler = completion

        try getHash()
        downloadSubtitle()
    }

    private func getHash() throws  {
        searchHash = try HashCalculator(filePath: filePath).getHash()
    }

    private func downloadSubtitle() {
        SubtitleDownloader(searchHash: searchHash!, language: language).downloadSubtitle(completion: downloadCallback)
    }

    private func downloadCallback(_ data: Data?, _ error: Error?) {
        guard error == nil, let data = data else {
            completionHandler?(error)
            return
        }

        do {
            try data.write(to: subtitleURL(), options: [.atomic])
        } catch {
            completionHandler?(error)
            return
        }

        completionHandler?(nil)
    }

    private func subtitleURL() -> URL {
        let path = (filePath as NSString).deletingPathExtension + "-\(language).srt"
        return URL(fileURLWithPath: path)
    }
}
