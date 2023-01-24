//
//  Reducers.swift
//  TODO
//
//  Created by e01919 on 15/10/22.
//

import ReSwift

func reducer(action: Action, state: AppState?) -> AppState {
    var state = state ?? AppState(todos: [])
    switch action {
    case let action as TODOActionAdd:
        state.todos += [action.todo]
    case let action as TODOActionDelete:
        state.todos.remove(at: action.index)
    case let action as TODOActionEdit:
        state.todos[action.index] = action.todo
    case let action as TODOActionFetchItems:
        state.todos = action.todos
    default:
        break
    }

    return state
}
