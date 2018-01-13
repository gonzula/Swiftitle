//
//  HashCalculator.swift
//  Swiftitle
//
//  Created by Gonzo Fialho on 13/01/18.
//  Copyright © 2018 Gonzo Fialho. All rights reserved.
//

import Cocoa

class HashCalculator {

    private var fileHandle: FileHandle

    let readSize = 64 * 1024

    convenience init(filePath: String) throws {
        try self.init(fileURL: URL(fileURLWithPath: filePath))
    }

    init(fileURL: URL) throws {
        fileHandle = try FileHandle(forReadingFrom: fileURL)
    }

    func getHash() -> String {
        let first = readData()
        seekSecondPart()
        let second = readData()

        let total = first + second

        return MD5(total)
    }

    private func readData() -> Data {
        return fileHandle.readData(ofLength: readSize)
    }

    private func seekSecondPart() {
        fileHandle.seekToEndOfFile()
        let size = fileHandle.offsetInFile
        fileHandle.seek(toFileOffset: size - UInt64(readSize))
    }

    private func MD5(_ messageData: Data) -> String {
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))

        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }

        return digestData.map { String(format: "%02hhx", $0) }.joined()
    }
}
