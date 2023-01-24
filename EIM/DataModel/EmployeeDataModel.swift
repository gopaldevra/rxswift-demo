//
//  EmployeeDataModel.swift
//  EIM
//
//  Created by e01919 on 16/10/22.
//

import Foundation

struct EmployeeDataModel: Codable {
    var name: String?
    var email: String?
    var isResigned: Bool = false
    var isNew: Bool = false
    
    /*
    static func dummy() -> [EmployeeDataModel] {
        let e = EmployeeDataModel(name: "Gopal", email: "gopal@gmail.com", isResigned: true)
        let e2 = EmployeeDataModel(name: "Ravi", email: "ravi@gmail.com", isResigned: true)
        let e3 = EmployeeDataModel(name: "Mukesh", email: "mukesh@gmail.com", isResigned: true)
        let e4 = EmployeeDataModel(name: "Miku", email: "miku@gmail.com", isResigned: false)
        
        return [e, e2, e3, e4]
    }
     */
}
