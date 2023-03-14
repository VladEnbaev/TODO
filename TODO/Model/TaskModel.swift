//
//  TaskModel.swift
//  lection13(tableView)
//
//  Created by Влад Енбаев on 21.02.2023.
//

import Foundation


struct Task : Codable, Equatable{
    var title : String
    var description : String
    var id : String
    var isOn : Bool
    
    init(title: String, description: String, isOn: Bool) {
        self.title = title
        self.description = description
        self.isOn = isOn
        self.id = UUID().uuidString
    }
}

extension Task {
    static let userDefaultsKey = Resources.Keys.userDefaultsKey
    
    static func save(_ tasks: [Task]){
        let data = try? JSONEncoder().encode(tasks)
        UserDefaults.standard.set(data, forKey: Task.userDefaultsKey)
    }
    static func loadTasks() -> [Task] {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else { return [] }
        let tasks = try? JSONDecoder().decode([Task].self, from: data)
        
        return tasks ?? []
    }
}
