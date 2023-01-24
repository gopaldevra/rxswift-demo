//
//  AddEditViewVM.swift
//  EIM
//
//  Created by e01919 on 19/10/22.
//

import Foundation
import RxCocoa
import RxSwift

struct AddEditViewVM {
    
    // MARK: - Properties
    
    var employee: EmployeeDataModel?
    var isEditMode = false
    var disposeBag = DisposeBag()
    
    // MARK: - Observable Properties
    var name = BehaviorRelay(value: "")
    var email = BehaviorRelay(value: "")
    var isResigned = BehaviorRelay(value: false)
    
    func initializeObservers(with employee: EmployeeDataModel) {
        self.name.accept(employee.name ?? "")
        self.email.accept(employee.email ?? "")
        self.isResigned.accept(employee.isResigned)
    }
    
    mutating func setEditMode() {
        isEditMode = employee != nil
    }
    
    mutating func updateEmployee() {
        employee?.name = name.value
        employee?.email = email.value
        employee?.isResigned = isResigned.value
        employee?.isNew = false
    }
}
