//
//  AddEditViewController.swift
//  EIM
//
//  Created by e01919 on 16/10/22.
//

import UIKit
import RxCocoa
import RxSwift

class AddEditViewController: UIViewController {
    // MARK: - Outlets
    
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var emailIdTextField: UITextField!
    @IBOutlet private weak var isResignedStatusSwitch: UISwitch!
    @IBOutlet private weak var buttonSave: UIButton!
    
    // MARK: - Properties
    
    private var viewModel = AddEditViewVM()
    var employee: EmployeeDataModel?
    var employeeObservable = PublishSubject<EmployeeDataModel>()
    
    // MARK: - View Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        emailIdTextField.delegate = self
        
        // Setting up editing mode based on passed employeeMO
        viewModel.employee = employee
        
        viewModel.setEditMode()
        
        bindDataOnUIInEditMode()
        
        observeUIObjects()
    }
    
    // MARK: - Data Binding
    
    private func bindDataOnUIInEditMode() {
        viewModel.name.subscribe(onNext: { name in
            self.nameTextField.text = name
        }).disposed(by: viewModel.disposeBag)
        
        viewModel.email.subscribe(onNext: { email in
            self.emailIdTextField.text = email
        }).disposed(by: viewModel.disposeBag)
        
        viewModel.isResigned.subscribe(onNext: { isResigned in
            self.isResignedStatusSwitch.isOn = isResigned
        }).disposed(by: viewModel.disposeBag)
        
        if viewModel.isEditMode {
            viewModel.initializeObservers(with: employee!)
        }
    }
    
    private func observeUIObjects() {
        nameTextField.rx
            .controlEvent(.editingChanged)
            .withLatestFrom(nameTextField.rx.text.orEmpty)
            .subscribe(onNext: { text in
                self.viewModel.name.accept(text)
            }).disposed(by: viewModel.disposeBag)
        
        emailIdTextField.rx
            .controlEvent(.editingChanged)
            .withLatestFrom(emailIdTextField.rx.text.orEmpty)
            .subscribe(onNext: { text in
                self.viewModel.email.accept(text)
            }).disposed(by: viewModel.disposeBag)
        
        isResignedStatusSwitch.rx
            .controlEvent(.valueChanged)
            .withLatestFrom(isResignedStatusSwitch.rx.isOn)
            .subscribe(onNext: { value in
                self.viewModel.isResigned.accept(value)
            }).disposed(by: viewModel.disposeBag)
        
        buttonSave.rx
            .controlEvent(.touchUpInside)
            .withLatestFrom(buttonSave.rx.tap)
            .subscribe(onNext: { sender in
                self.saveEmployeeData()
            }).disposed(by: viewModel.disposeBag)
    }
    
    // MARK: - Action
    
    private func saveEmployeeData() {
        guard let name = nameTextField.text, let email = emailIdTextField.text else {
            showToast(message: "Please fill out all fields",
                      seconds: 2,
                      backgrndColor: .red,
                      radius: 20)
            return
        }
        
        if name.isEmpty || email.isEmpty {
            showToast(message: "Please fill out all fields",
                      seconds: 2,
                      backgrndColor: .red,
                      radius: 20)
            return
        }
        
        if viewModel.isEditMode {
            // Update employee
            updateEmployee(name: name,
                           emailId: email,
                           isResigned: isResignedStatusSwitch.isOn)
        } else {
            // Add new employee
            let newEmployee = EmployeeDataModel(name: name,
                                                email: email,
                                                isResigned: isResignedStatusSwitch.isOn,
                                                isNew: true)
            employeeObservable.onNext(newEmployee)
        }
        
        if viewModel.isEditMode {
            showToast(message: "Record Updated Successfully",
                      seconds: 2,
                      backgrndColor: .blue)
            resetUI()
        } else {
            showToast(message: "Record Saved Successfully",
                      seconds: 2,
                      backgrndColor: .purple)
            resetUI()
        }
    }
    
    // MARK: - Private helper methods
    
    private func updateEmployee(name:String,
                                emailId:String,
                                isResigned: Bool) {
        viewModel.updateEmployee()
        employeeObservable.onNext(viewModel.employee!)
    }
    
    private func resetUI() {
        self.nameTextField.text = ""
        self.emailIdTextField.text = ""
    }
    
    private func showToast(message: String, seconds: Double, backgrndColor: UIColor = UIColor.black, radius: CGFloat = 15) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = backgrndColor
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = radius
        
        self.present(alert, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+seconds) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - UITextFieldDelegate

extension AddEditViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true;
    }
}
