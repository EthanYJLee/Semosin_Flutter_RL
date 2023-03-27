//
//  StateBarUIView.swift
//  administrator
//
//  Created by 권순형 on 2023/03/24.
//

import UIKit

class StateBarUIView: UIView {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblState:UILabel!
    
    var title:String?
    var content:String?
    
    override init(frame: CGRect) {
        self.title = ""
        self.content = ""
        super.init(frame: frame)
//        setup()
    }

    // storyboard에서 만들 떄 불려진다.
    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        setup()
    }
    
    
    /// 날짜 : 2023.03.24
    /// 만든이 : 권순형
    /// 설명 : 전체 세팅
    func setup(){
        viewSetup()
        componentSetup()
    }
    
    /// 날짜 : 2023.03.24
    /// 만든이 : 권순형
    /// 설명 : 뷰 모양 세팅
    func viewSetup(){
        // 각 뷰에다가 복사하기
        self.layer.cornerRadius = 10
        self.addBottomShadow()
        // -----------------
    }
    
    /// 날짜 : 2023.03.24
    /// 만든이 : 권순형
    /// 설명 : 요소 세팅
    func componentSetup(){
        
        let lblTitle = UILabel()
        let lblState = UILabel()
        
        self.addSubview(lblTitle)
        self.addSubview(lblState)
        
        lblTitle.anchor(top: self.safeAreaLayoutGuide.topAnchor,
                        leading: self.safeAreaLayoutGuide.leadingAnchor,
                        bottom: nil,
                        trailing: self.safeAreaLayoutGuide.trailingAnchor,
                        padding: .init(top: 15, left: 0, bottom: 0, right: 0)
                        )
        
        lblState.anchor(top: lblTitle.topAnchor,
                        leading: lblTitle.leadingAnchor,
                        bottom: self.safeAreaLayoutGuide.bottomAnchor,
                        trailing: lblTitle.trailingAnchor,
                        padding: .init(top: 30, left: 0, bottom: 0, right: 0)
                        )
        
        lblTitle.textAlignment = .center
        lblState.textAlignment = .center
        
        lblTitle.text = title
        lblTitle.font = UIFont.systemFont(ofSize: CGFloat(20), weight: .medium)
        lblTitle.textColor = .lightGray
        
        lblState.text = content
        lblState.font = UIFont.systemFont(ofSize: CGFloat(25), weight: .bold)
        lblState.textColor = .darkGray
        
        self.lblTitle = lblTitle
        self.lblState = lblState
        
        // lable Text 값 바
    }

}
