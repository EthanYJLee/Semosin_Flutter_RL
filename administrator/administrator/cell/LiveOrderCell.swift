//
//  LiveOrderCell.swift
//  administrator
//
//  Created by usonihs on 2023/03/24.
//

import UIKit

class LiveOrderCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    
    var cellId = "LiveOrderCell"
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let queryModel = QueryModel()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
