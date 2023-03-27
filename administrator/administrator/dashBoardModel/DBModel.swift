//
//  DBModel.swift
//  administrator
//
//  Created by usonihs on 2023/03/24.
//

import Foundation

struct DBModel {
    
    var documentId: String
    var orderdate: String
    var name: String
    var request: String
    
    init(documentId: String, code: String, name: String, dept:String) {
        self.documentId = documentId
        self.orderdate = orderdate
        self.name = name
        self.request = request
    }
}
