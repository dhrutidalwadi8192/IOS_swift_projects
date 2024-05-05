//
//  MapHistoryTableViewCell.swift
//  Dhrutiben_Dalwadi_FE_8968192
//
//  Created by user237515 on 4/14/24.
//

import UIKit

class MapHistoryTableViewCell: UITableViewCell {

    // city name
    @IBOutlet weak var cityName: UILabel!
    
    // interaction source
    @IBOutlet weak var interactionSource: UILabel!
    
    // start location
    @IBOutlet weak var startLocation: UILabel!
    
   // end location
    @IBOutlet weak var endLocation: UILabel!
    
    // travel mode
    @IBOutlet weak var travelMode: UILabel!
    
    // distance travelled
    @IBOutlet weak var distance: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
