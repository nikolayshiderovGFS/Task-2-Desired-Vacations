//
//  VacationCell.swift
//  Task 2 Desired Vacations
//
//  Created by Nikolay Shiderov on 29.10.21.
//

import UIKit

class VacationCell: UITableViewCell {

    @IBOutlet weak var imageViewVacation: UIImageView!
    @IBOutlet weak var textLabelVacation: UILabel!
    @IBOutlet weak var textLabelHotel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setData(desiredVacation dv: DesiredVacation) {
        textLabelVacation.text = dv.name
        textLabelHotel.text = dv.hotelName
        if let img = dv.image {
            imageViewVacation.image = UIImage(data: img, scale:1.0)
        }

    }
    
}
