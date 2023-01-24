//
//  EmployeesViewController.swift
//  EIM
//
//  Created by e01919 on 16/10/22.
//

import UIKit
import RxSwift
import RxCocoa


class EmployeesViewController: UITableViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var barButtonAdd: UIBarButtonItem!
    
    // MARK: - Properties
    
    private let viewModel = EmployeeViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        bindTableView()
        observeUIObjects()
    }
    
    // MARK: Observe UI Objects
    
    private func observeUIObjects() {
        barButtonAdd.rx.tap.subscribe(onNext: { sender in
            self.showVCAddEdit()
        }).disposed(by: disposeBag)
    }
    
    private func bindTableView() {
        viewModel.employeesObservable
            .bind(to: tableView.rx
                .items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
                    cell.textLabel?.text = element.name
                }
                .disposed(by: disposeBag)
        
        // Selected item
        tableView.rx.modelSelected(EmployeeDataModel.self).subscribe(onNext: { item in
            print("SelectedItem: \(String(describing: item.name))")
            
            self.showVCAddEdit(employee: item)
        }).disposed(by: disposeBag)
        
        viewModel.fetchEmployees()
    }
    
    // MARK: - Action
    
    private func showVCAddEdit(employee: EmployeeDataModel? = nil) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddEditViewController") as? AddEditViewController
        // Pass selected employee
        vc?.employee = employee
        
        // Subscribe to any update to employee object from AddEditViewController
        vc?.employeeObservable.subscribe(onNext: { employee in
            // Observe employee update here from AddEditViewController
            if employee.isNew {
                // Save new employee
                self.viewModel.saveNew(employee: employee)
            } else {
                // Update selected employee
                self.save(updatedEmployee: employee)
            }
            // Update in table view
            self.viewModel.fetchEmployees()
        }).disposed(by: disposeBag)
        
        self.show(vc!, sender: self)
    }
    
    // MARK: - Private helper methods
    
    private func save(updatedEmployee: EmployeeDataModel) {
        viewModel.save(updatedEmployee: updatedEmployee)
    }
    
}
