//
//  InventoryTableViewCell.swift
//  eXpire
//
//  Created by Scott English on 11/15/17.
//  Copyright © 2017 Scott English. All rights reserved.
//

import UIKit

class InventoryTableViewCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var foodnameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // Configure the view for the selected state
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
