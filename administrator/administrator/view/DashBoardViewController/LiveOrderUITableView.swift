//
//  LiveOrderUITableView.swift
//  administrator
//
//  Created by usonihs on 2023/03/24.
//

import UIKit

class LiveOrderUITableView: UITableView {
    
    var newOrderList: [DBModel] = []

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup(){
        self.register(LiveOrderCell.self, forCellReuseIdentifier: LiveOrderCell.self)
        self.dataSource = self
        self.delegate = self
    }

}

extension LiveOrderUITableView: UITableViewDelegate{}

extension LiveOrderUITableView: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        // cell section 몇개인지
    }
    
    func tableView(_ tableView: LiveOrderUITableView, numberOfRowsInSection section: Int) -> Int {
        return newOrderList.count
        // data length 들어가면 됨
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 85
//    }
    
    func tableView(_ tableView: LiveOrderUITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LiveOrderCell" ,for: indexPath) as! LiveOrderCell
        
        var asd = newOrderList[indexPath.row]["documentId"]
        cell.lblDate.text = newOrderList[indexPath.row]["orderDate"]
        cell.lblName.text = newOrderList[indexPath.row]["name"]
        cell.lblContent.text = newOrderList[indexPath.row]["deliveryRequest"]
        
        
        return cell

    }
    
    
} // table view


