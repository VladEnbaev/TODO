//
//  Protocols.swift
//  lection13(tableView)
//
//  Created by Влад Енбаев on 07.03.2023.
//

import UIKit

protocol TableViewCellDelegate : AnyObject{
    func didChangeActivity(_ cell: TableViewCell, isActive: Bool)
}

protocol NewOrChangedTaskViewControllerDelegate : AnyObject{
    func addNew(task: Task)
    func change(task: Task, on indexPath: IndexPath)
}

protocol MasterVCDelegate : AnyObject{
    func prepareForAppear(with task: Task, and indexPath: IndexPath, sender: AnyObject)
}
