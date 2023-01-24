//
//  ViewController.swift
//  TODO
//
//  Created by e01919 on 15/10/22.
//

import UIKit
import ReSwift

class TODOViewController: UIViewController {
    
    // MARK: UI Elements
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(TODOCell.self, forCellReuseIdentifier: TODOCell.description())
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    // MARK: - Properties
    
    fileprivate var todos = [TODO]()
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Todo"
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        // Subscribe to store of ReSwift
        mainStore.subscribe(self)
        
        // Show todos on table
        mainStore.dispatch(TODOActionFetchItems(todos: JSONOperations().readData()))
        
        // Bar button item to add todo
        addBarButtonAddTodo()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: - Actions
    
    @objc private func didAddTodoTapped() {
        showTODOAddAlert()
    }
    
    // MARK: - Private helper methods
    
    
    /// Bar button add item to adding new todo
    private func addBarButtonAddTodo() {
        let barbutton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didAddTodoTapped))
        self.navigationItem.rightBarButtonItem = barbutton
    }
    
    /// Show action sheet with options to user when tapping on todo item in table view
    /// - Parameter index: selected todo index
    private func showTodoActionSheet(at index: Int) {
        let alert = UIAlertController(title: "Select options from below", message: nil, preferredStyle: .actionSheet)
        
        // Edit action
        alert.addAction(UIAlertAction(title: "Edit", style: .default , handler:{ (UIAlertAction)in
            print("User click Edit button")
            self.showTODOEditAlert(at: index)
        }))
        
        // Delete action
        alert.addAction(UIAlertAction(title: "Delete", style: .default , handler:{ (UIAlertAction)in
            print("User click Delete button")
            mainStore.dispatch(TODOActionDelete(index: index))
        }))
        
        // Delete action
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler:{ (UIAlertAction)in
            print("User click Cancel button")
        }))
        
        alert.popoverPresentationController?.sourceView = self.view
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    
    /// Edit todo at index
    /// - Parameter index: todo index
    private func showTODOEditAlert(at index: Int) {
        let alert = UIAlertController(title: "Select options from below", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Edit Todo name"
        }
        
        alert.addAction(UIAlertAction(title: "Rename", style: .default , handler:{ (UIAlertAction)in
            print("User click Rename button")
            var film = self.todos[index]
            film.title = alert.textFields?[0].text ?? ""
            mainStore.dispatch(TODOActionEdit(todo: film, index: index))
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler:{ (UIAlertAction)in
            print("User click Cancel button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    /// Add new todo
    private func showTODOAddAlert() {
        let alert = UIAlertController(title: "Add Todo", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Name of the todo"
        }
        
        alert.addAction(UIAlertAction(title: "Add", style: .default , handler:{ (UIAlertAction)in
            print("User click Add button")
            let todo = TODO(title: alert.textFields?[0].text ?? "")
            mainStore.dispatch(TODOActionAdd(todo: todo))
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler:{ (UIAlertAction)in
            print("User click Cancel button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    // MARK: - De init
    
    deinit {
        mainStore.unsubscribe(self)
    }
}

// MARK: - UITableViewDataSource

extension TODOViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TODOCell.description(), for: indexPath)
        let film = todos[indexPath.row]
        cell.textLabel?.text = film.title
        return cell
    }
}

// MARK: - UITableViewDelegate

extension TODOViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Show options to user for todo
        showTodoActionSheet(at: indexPath.row)
    }
}

// MARK: - StoreSubscriber

extension TODOViewController: StoreSubscriber {
    func newState(state: AppState) {
        // Save data to JSON
        JSONOperations().writeData(state.todos)
        
        self.todos = state.todos
        self.tableView.reloadData()
    }
}
