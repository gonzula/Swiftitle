//
//  SubtitleDownloader.swift
//  Swiftitle
//
//  Created by Gonzo Fialho on 13/01/18.
//  Copyright © 2018 Gonzo Fialho. All rights reserved.
//

import Cocoa

class SubtitleDownloader {

    enum SubtitleDownloaderError: Error {
        case remoteError
    }

    var searchHash: String
    var language: String

    private var session: URLSession?
    private var dataTask: URLSessionDataTask?

    private var url: URL?
    private var request: URLRequest?

    private var userAgent: String {
        let clientName = "Swiftitler"
        let clientVersion = "1.0"
        let clientURL = "http://example.com"
        let userAgent = "SubDB/1.0 (\(clientName)/\(clientVersion); \(clientURL))"
        return userAgent
    }

    init(searchHash: String, language: String) {
        self.searchHash = searchHash
        self.language = language
    }

    func downloadSubtitle(completion: @escaping (Data?, Error?)->Void) {
        configureSession()
        configureRequest()

        dataTask?.cancel()
        dataTask = session?.dataTask(with: request!) { data, response, error in
            defer { self.dataTask = nil }

            guard error == nil, let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                DispatchQueue.main.async {
                    completion(nil, error ?? SubtitleDownloaderError.remoteError)
                }
                return
            }

            DispatchQueue.main.async {
                completion(data, nil)
            }
        }
        dataTask?.resume()
    }

    private func configureSession() {
        session = URLSession(configuration: .ephemeral)
    }

    private func configureRequest() {
        configureURL()
        request = URLRequest(url: url!)
        request!.setValue(userAgent, forHTTPHeaderField: "user-agent")
    }

    private func configureURL() {
        var urlComponents = URLComponents(string: "http://api.thesubdb.com/")!
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "action", value: "download"))
        queryItems.append(URLQueryItem(name: "hash", value: searchHash))
        queryItems.append(URLQueryItem(name: "language", value: language))
        urlComponents.queryItems = queryItems
        url = urlComponents.url!
    }
}
