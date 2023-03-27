//
//  QueryModel.swift
//  administrator
//
//  Created by usonihs on 2023/03/24.
//

import Foundation
import Firebase

protocol QueryModelProtocol {
    func itemDownloaded(items: [DBModel])
}

class QueryModel {
    var delegate: QueryModelProtocol!
    let db = Firestore.firestore()
    
    func downloadItems() {
        var locations: [DBModel] = []
        
        db.collection("users").document().collection("orders").whereField("orderStatus", isEqualTo: "1").getDocuments(completion: {(querySnapShot, err)
            in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                print("Data is downloaded.")
                for document in querySnapShot!.documents {
                    guard let data = document.data()["orderDate"] else {return}
                    print("\(document.documentID) => \(data)")
                    
                    let query = DBModel(
                        documentId: document.documentID,
                        orderdate: document.data()["orderDate"] as! String,
                        name: document.data()["name"] as! String,
                        request: document.data()["deliveryRequest"] as! String)
                    print(query)
                    locations.append(query)
                }
                DispatchQueue.main.async {
                    self.delegate.itemDownloaded(items: locations)
                }
            }
            
        })
    }
}
