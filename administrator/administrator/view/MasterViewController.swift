//
//  MasterViewController.swift
//  administrator
//
//  Created by 권순형 on 2023/03/23.
//

import UIKit

class MasterViewController: UIViewController {
    
    @IBOutlet var tvListView: UITableView!
    
    var category = ["대시 보드","배송 조회"]

    override func viewDidLoad() {
        super.viewDidLoad()
    
        tvListView.dataSource = self
        tvListView.delegate = self
    }

}

extension MasterViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = category[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(indexPath)
        
        if(indexPath.row == 0){
            self.performSegue(withIdentifier: "dashboardSegue", sender: nil)
        }
        
        if(indexPath.row == 1){
            self.performSegue(withIdentifier: "mapSegue", sender: nil)
        }
        
    }
  
}
