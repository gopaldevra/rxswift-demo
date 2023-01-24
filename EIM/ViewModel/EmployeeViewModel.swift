//
//  EmployeeViewModel.swift
//  EIM
//
//  Created by e01919 on 16/10/22.
//

import Foundation

import Foundation
import CoreData
import RxSwift
import RxCocoa

class EmployeeViewModel {
    init() {}
    
    // Observable
    let employeesObservable = PublishSubject<[EmployeeDataModel]>()
    
    func fetchEmployees() {
        let employees = JSONOperations().readData()
        employeesObservable.onNext(employees)
    }
    
    func save(updatedEmployee: EmployeeDataModel) {
        var employees = JSONOperations().readData()
        for i in 0..<employees.count {
            if updatedEmployee.email == employees[i].email {
                employees[i] = updatedEmployee
                break
            }
        }
        
        JSONOperations().writeData(employees)
    }
    
    func saveNew(employee: EmployeeDataModel) {
        var employees = JSONOperations().readData()
        employees += [employee]
        JSONOperations().writeData(employees)
    }
}
