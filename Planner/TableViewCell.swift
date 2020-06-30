// Jiating Su
// 111665989
//
//  TableViewCell.swift
//  Planner
//
//  Created by 郑植 on 6/23/20.
//  Copyright © 2020 CSE 390. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var main: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
