//
//  JSONOperations.swift
//  TODO
//
//  Created by e01919 on 15/10/22.
//

import Foundation

struct JSONOperations {
    private let todoFileName = "todo.json"
    
    func writeData(_ totals: [TODO]) {
        if totals.isEmpty { return }
        do {
            var url: URL?
            if let path = isFileExists() {
                url = URL(fileURLWithPath: path)
                print("Second time")
            } else {
                print("first time")
                url = try FileManager.default
                    .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    .appendingPathComponent(todoFileName)
            }
            
            try JSONEncoder()
                .encode(totals)
                .write(to: url!)
        } catch {
            print("error writing data")
        }
    }
    
    private func isFileExists() -> String? {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent(todoFileName) {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                print("FILE AVAILABLE")
                return filePath
            } else {
                print("FILE NOT AVAILABLE")
                return nil
            }
        } else {
            print("FILE PATH NOT AVAILABLE")
            return nil
        }
    }
    
    func readData() -> [TODO] {
        do {
            
            let url = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent(todoFileName)
            
            let data = try Data(contentsOf: url)
            let pastData = try JSONDecoder().decode([TODO].self, from: data)
            
            return pastData
        } catch {
            print("error reading data")
            return []
        }
    }
}
