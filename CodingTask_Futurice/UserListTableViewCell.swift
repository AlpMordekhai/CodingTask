//
//  UserListTableViewCell.swift
//  CodingTask_Futurice
//
//  Created by Alberto Lopez on 13/03/16.
//  Copyright © 2016 AlbertoLopez. All rights reserved.
//

import UIKit

class UserListTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var lblUppercase: UILabel!
    @IBOutlet weak var lblBackground: UILabel!
    
    var username : String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblBackground.layer.cornerRadius = 0.5 * lblBackground.frame.height //used to round the cell
        self.lblBackground.layer.masksToBounds = true;
        
        let k: Int = random() % 14
        let red : [CGFloat] = [98.0,41,58,14873,209,52,247,246,239,206,181,162,117,67]
        let green : [CGFloat] = [191,189,127,97,84,213,102,161,199,121,71,47,143,112,170,]
        let blue : [CGFloat] = [112,156,199,182,118,216,174,51,48,58,67,49,132,107,97]
        
        let newColor = UIColor(red: (red[k]/255.0), green: (green[k]/255.0), blue: (blue[k]/255.0), alpha: 1.0)
        self.lblBackground.backgroundColor = newColor
        
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }


}
