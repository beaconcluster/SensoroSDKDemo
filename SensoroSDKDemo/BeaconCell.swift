//
//  BeaconCell.swift
//  SensoroSDKDemo
//
//  Created by David Yang on 15/1/26.
//  Copyright (c) 2015年 beaconcluster. All rights reserved.
//

import UIKit

class BeaconCell: UITableViewCell {

    @IBOutlet weak var UUID: UILabel!
    @IBOutlet weak var SN: UILabel!
    @IBOutlet weak var majorAndMinor: UILabel!
    @IBOutlet weak var modelInfo: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
