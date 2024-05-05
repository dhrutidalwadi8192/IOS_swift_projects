//
//  NewsTableViewCell.swift
//  Dhrutiben_Dalwadi_FE_8968192
//
//  Created by user237515 on 4/13/24.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    // news title
    @IBOutlet weak var newsTitle: UILabel!
    
    // news description
    @IBOutlet weak var newsDescription: UITextView!
    
    // news source
    @IBOutlet weak var newsSource: UILabel!
    
    // news author
    @IBOutlet weak var newsAuthor: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
