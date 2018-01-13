//
//  Movie.swift
//  Swiftitle
//
//  Created by Gonzo Fialho on 13/01/18.
//  Copyright © 2018 Gonzo Fialho. All rights reserved.
//

import Cocoa

class Movie {

    enum State: String {
        case waiting
        case downloading
        case done
        case error
    }

    var state: State = .waiting

    var name: String {
        return url.lastPathComponent
    }

    var url: URL

    init(url: URL) {
        self.url = url
    }
}

extension Movie: Equatable {

    static func ==(lhs: Movie, rhs: Movie) -> Bool {
        return lhs.url == rhs.url
    }

}
