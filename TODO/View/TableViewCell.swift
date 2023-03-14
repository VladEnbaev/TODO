//
//  TableViewCell.swift
//  lection13(tableView)
//
//  Created by Влад Енбаев on 21.02.2023.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionsLabel: UILabel!
    @IBOutlet weak var mySwitch: UISwitch!
    
    private var task : Task?
    
    weak var delegate : TableViewCellDelegate?
    
    public func configure(with task: Task) {
        self.task = task
        //view
        self.layer.borderWidth = 3
        self.layer.borderColor = Resources.Colors.secondGrayColor.cgColor
        self.layer.cornerRadius = 10
        //titlelabel
        titleLabel.text = task.title
        titleLabel.layer.borderColor = Resources.Colors.secondGrayColor.cgColor
        titleLabel.layer.borderWidth = 1
        titleLabel.layer.cornerRadius = 3
        //description label
        descriptionsLabel.text = task.description
        descriptionsLabel.layer.borderColor = Resources.Colors.secondGrayColor.cgColor
        descriptionsLabel.layer.borderWidth = 1
        descriptionsLabel.layer.cornerRadius = 3
        //switch
        mySwitch.isOn = task.isOn
        mySwitch.layer.borderColor = Resources.Colors.secondGrayColor.cgColor
        mySwitch.layer.borderWidth = 1
        mySwitch.onTintColor = Resources.Colors.mainThemeColor
        
    }
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        self.delegate?.didChangeActivity(self, isActive: sender.isOn)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
