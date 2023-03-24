//
//  style.swift
//  administrator
//
//  Created by 권순형 on 2023/03/24.
//

import Foundation
import UIKit

/// 날짜 : 2023.03.24
/// 만든이 : 권순형
/// 설명 : UIView exension 한군데에 몰아 넣어서 재사용시에 용이하게 하기
extension UIView{
    
    /// 날짜 : 2023.03.24
    /// 만든이 : 권순형
    /// 설명 : UIView constraints 조정 방법
    func anchor(top : NSLayoutYAxisAnchor? , leading : NSLayoutXAxisAnchor? , bottom : NSLayoutYAxisAnchor? , trailing : NSLayoutXAxisAnchor?, padding : UIEdgeInsets = .zero , size : CGSize = .zero ){
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top{
            topAnchor.constraint(equalTo: top , constant: padding.top).isActive = true
        }
        
        if let leading = leading{
            leadingAnchor.constraint(equalTo: leading , constant: padding.left).isActive = true
        }
        
        if let bottom = bottom{
            bottomAnchor.constraint(equalTo: bottom , constant: padding.bottom).isActive = true
        }
        
        if let trailing = trailing{
            trailingAnchor.constraint(equalTo: trailing , constant: padding.right).isActive = true
        }

        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    func addBottomShadow() {
        layer.masksToBounds = false
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.4
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 0 , height: 3)
    }
}
