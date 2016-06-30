//
//  MolTableViewCell.swift
//  NMR Spectra
//
//  Created by Alican Toprak on 30.06.16.
//  Copyright © 2016 Alican Toprak. All rights reserved.
//

import UIKit

class MolTableViewCell: UITableViewCell {

    @IBOutlet weak var imageVIew: UIImageView!
    @IBOutlet weak var nameView: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
