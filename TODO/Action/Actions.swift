//
//  Actions.swift
//  TODO
//
//  Created by e01919 on 15/10/22.
//

import ReSwift

struct TODOActionAdd: Action {
    let todo: TODO
}

struct TODOActionDelete: Action {
    let index: Int
}

struct TODOActionEdit: Action {
    let todo: TODO
    let index: Int
}

struct TODOActionFetchItems: Action {
    let todos: [TODO]
}
