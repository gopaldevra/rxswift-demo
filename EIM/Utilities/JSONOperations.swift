//
//  JSONOperations.swift
//  EIM
//
//  Created by e01919 on 16/10/22.
//

import Foundation

struct JSONOperations {
    private let fileName = "employees.json"
    
    func writeData(_ employees: [EmployeeDataModel]) {
        if employees.isEmpty { return }
        do {
            var url: URL?
            if let path = isFileExists() {
                url = URL(fileURLWithPath: path)
                print("Second time")
            } else {
                print("first time")
                url = try FileManager.default
                    .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    .appendingPathComponent(fileName)
            }
            try JSONEncoder()
                .encode(employees)
                .write(to: url!)
        } catch {
            print("error writing data")
        }
    }
    
    private func isFileExists() -> String? {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent(fileName) {
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
    
    func readData() -> [EmployeeDataModel] {
        do {
            let url = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent(fileName)
            
            let data = try Data(contentsOf: url)
            let pastData = try JSONDecoder().decode([EmployeeDataModel].self, from: data)
            
            return pastData
        } catch {
            print("error reading data")
            return []
        }
    }
}
