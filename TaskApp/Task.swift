//
//  Task.swift
//  TaskApp
//
//  Created by Tsuji Kota on 30.04.2024.
//

import RealmSwift

class Task: Object{
    @Persisted(primaryKey: true) var id :ObjectId
    @Persisted var title = ""
    @Persisted var contents = ""
    @Persisted var date = Date()
    @Persisted var category = ""
    
}
