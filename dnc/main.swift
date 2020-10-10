//
//  main.swift
//  dnc
//
//  Created by Tyler Hall on 10/10/20.
//

import Foundation
import ArgumentParser

struct DNCOptions: ParsableArguments {
    @Option(name: .shortAndLong, help: ArgumentHelp("The directory to recursively scan.", valueName: "directory"))
    var directory: String

    @Option(name: .shortAndLong, help: ArgumentHelp("A string to search for in the filename of the directory's files.", valueName: "string"))
    var query: String

    @Flag(help: "Invert the query. i.e., show directories that DO contain the query.")
    var invert = false
}

var directoryPath: String
var query: String
var invert = false

if (CommandLine.arguments.count == 2) && (CommandLine.arguments[1] != "--help") {
    directoryPath = FileManager.default.currentDirectoryPath
    query = CommandLine.arguments[1]
} else {
    let options = DNCOptions.parseOrExit()
    directoryPath = options.directory
    query = options.query
    invert = options.invert
}

var isDir: ObjCBool = false
guard FileManager.default.fileExists(atPath: directoryPath, isDirectory: &isDir), isDir.boolValue else {
    print("Error: \(directoryPath) is not accessible.")
    exit(EXIT_FAILURE)
}

func checkDirectoryURL(_ dirURL: URL, query: String) {
    guard let files = try? FileManager.default.contentsOfDirectory(at: dirURL, includingPropertiesForKeys: nil, options: []) else { return }

    var isMissingQuery = true
    for fileURL in files {
        if fileURL.lastPathComponent.contains(query) {
            isMissingQuery = false
        }

        var isDir: ObjCBool = false
        let exists = FileManager.default.fileExists(atPath: fileURL.path, isDirectory: &isDir)
        if exists && isDir.boolValue {
            checkDirectoryURL(fileURL, query: query)
        }
    }

    if invert {
        if !isMissingQuery {
            print(dirURL.path)
        }
    } else {
        if isMissingQuery {
            print(dirURL.path)
        }
    }
}

let directoryURL = URL(fileURLWithPath: directoryPath)
checkDirectoryURL(directoryURL, query: query)
