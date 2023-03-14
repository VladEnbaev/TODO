//
//  Resources.swift
//  lection13(tableView)
//
//  Created by Влад Енбаев on 05.03.2023.
//

import UIKit

enum Resources {
    enum Colors {
        static var mainThemeColor  = UIColor.systemBlue
        static var secondColor     = UIColor.blue
        static var mainGreyColor   = UIColor.darkGray
        static var secondGrayColor = UIColor.systemGray
    }
    enum Identifiers{
        static var masterVCNibName        = "MasterTableViewController"
        static var detailVCNibName        = "DetailViewController"
        static var cellNibName            = "TableViewCell"
        static var xibCellReuseIdentifier = "xibTableViewCellID"
        
    }
    enum Keys {
        static var userDefaultsKey = "TasksKey"
    }
}
