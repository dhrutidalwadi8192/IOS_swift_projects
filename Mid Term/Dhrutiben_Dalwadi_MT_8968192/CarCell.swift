//
//  CarCell.swift
//  Dhrutiben_Dalwadi_MT_8968192
//
//  Created by user237515 on 3/1/24.
//

import UIKit

class CarCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

  
    // map car cell view controls
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var carName: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
