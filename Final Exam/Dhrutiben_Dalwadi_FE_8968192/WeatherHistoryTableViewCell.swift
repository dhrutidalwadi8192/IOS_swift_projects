//
//  WeatherHistoryTableViewCell.swift
//  Dhrutiben_Dalwadi_FE_8968192
//
//  Created by user237515 on 4/14/24.
//

import UIKit

class WeatherHistoryTableViewCell: UITableViewCell {

    
    // city name
    @IBOutlet weak var cityName: UILabel!
    
    // interaction source
    @IBOutlet weak var interactionSource: UILabel!
    
    // weather date
    @IBOutlet weak var weatherDate: UILabel!
    
    // weather time
    @IBOutlet weak var weatherTime: UILabel!
    
    // temperature
    @IBOutlet weak var temperature: UILabel!
    
    // humidity
    @IBOutlet weak var humidity: UILabel!
    
    // wind speed
    @IBOutlet weak var windSpeed: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
