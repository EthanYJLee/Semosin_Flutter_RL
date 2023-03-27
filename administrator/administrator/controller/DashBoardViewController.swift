//
//  DetailOneViewController.swift
//  administrator
//
//  Created by 권순형 on 2023/03/23.
//

import UIKit

class DashBoardViewController: UIViewController {

    @IBOutlet weak var liveOrderUITableView: LiveOrderUITableView!
    @IBOutlet weak var complainUITableView: ComplainUITableView!
    @IBOutlet weak var priceUITableView: PriceUITableView!
    
    var newOrderList: [DBModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let splitView = self.navigationController?.splitViewController, !splitView.isCollapsed{
            self.navigationItem.leftBarButtonItem = splitView.displayModeButtonItem
        }
    }
    
//    func reloadAction() {
//        let queryModel = QueryModel()
//        queryModel.delegate = self
//        queryModel.downloadItems()
//        print("*********")
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
//    override func numberOfSections(in tableView: LiveOrderUITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//
//    override func tableView(_ tableView: LiveOrderUITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return newOrderList.count
//    }
//
//
//    override func tableView(_ tableView: LiveOrderUITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "LiveOrderCell", for: indexPath) // withIdentifier 꼭 하기 **************
//
//        // Configure the cell...
//        lblDate.text =
//        content.secondaryText = "학번 : \(studentStore[indexPath.row].code)"
//        cell.contentConfiguration = content
//
//        return cell
//    }

}
