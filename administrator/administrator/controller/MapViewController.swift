//
//  DetailTwoViewController.swift
//  administrator
//
//  Created by 권순형 on 2023/03/23.
//

import UIKit

class MapViewController: UIViewController {

    @IBOutlet weak var searchbarUIView: SearchBarUIView!
    
    @IBOutlet weak var inDeliveryUIView: StateBarUIView!
    @IBOutlet weak var delayDeliveryUIView: StateBarUIView!
    @IBOutlet weak var completeDeliveryUIView: StateBarUIView!
    @IBOutlet weak var delayPercentageUIView: StateBarUIView!
    
    
    @IBOutlet weak var mapUIView: MapUIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let splitView = self.navigationController?.splitViewController, !splitView.isCollapsed{
            self.navigationItem.leftBarButtonItem = splitView.displayModeButtonItem
        }
        
        // 배송 상태 관련 UI build
        setStateUIViewText()
    }
    
    
    
    /// 날짜 : 2023.03.24
    /// 만든이 : 권순형
    /// 설명 : stateUI 값 변경
    func setStateUIViewText(){
        inDeliveryUIView.title = "배송 중"
        delayDeliveryUIView.title = "배송 지연"
        completeDeliveryUIView.title = "배송 완료"
        delayPercentageUIView.title = "지연율"
        
        inDeliveryUIView.content = "10%"
        delayDeliveryUIView.content = "10%"
        completeDeliveryUIView.content = "10%"
        delayPercentageUIView.content = "10%"
        
        inDeliveryUIView.setup()
        delayDeliveryUIView.setup()
        completeDeliveryUIView.setup()
        delayPercentageUIView.setup()
    }

}
