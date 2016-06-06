//
//  PayCell.swift
//  Tip
//
//  Created by Johnny Pham on 6/6/16.
//  Copyright © 2016 Johnny Pham. All rights reserved.
//

import UIKit
import CoreData
class PayCell: UITableViewCell {
  
  @IBOutlet weak var payAmount: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var payItemView: UIView!
  
  
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    payItemView.layer.cornerRadius = 5
    payItemView.clipsToBounds = true
  }

}
