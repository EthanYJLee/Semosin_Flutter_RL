//
//  SearchBarUIView.swift
//  administrator
//
//  Created by 권순형 on 2023/03/24.
//

import UIKit

class SearchBarUIView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
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
        self.layer.cornerRadius = 10
        self.addBottomShadow()
    }
    
    /// 날짜 : 2023.03.24
    /// 만든이 : 권순형
    /// 설명 : 요소 세팅
    func componentSetup(){
        
    }

}
