//
//  DetailTwoViewController.swift
//  administrator
//
//  Created by 권순형 on 2023/03/23.
//

import UIKit

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let splitView = self.navigationController?.splitViewController, !splitView.isCollapsed{
            self.navigationItem.leftBarButtonItem = splitView.displayModeButtonItem
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
