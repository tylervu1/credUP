//
//  paymentsTableViewCell.swift
//  credup
//
//  Created by Ryan Reid on 2/18/23.
//

import UIKit

class paymentsTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var paymentRecipts: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var message: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
