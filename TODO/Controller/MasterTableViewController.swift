//
//  MasterTableViewController.swift
//  lection13(tableView)
//
//  Created by Влад Енбаев on 05.03.2023.
//

import UIKit

class MasterTableViewController: UITableViewController {
    
    var tasks : [Task] = Task.loadTasks() {
        didSet {
            Task.save(tasks)
        }
    }
    
    weak var delegate : MasterVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableViewCell()
        // navigation controller
        let plusButton = createPlusButton()
        setNavigatinController(with: plusButton)
        //table view
        self.tableView.separatorColor = .none
    }
    
    func registerTableViewCell(){
        let nib = UINib(nibName: Resources.Identifiers.cellNibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Resources.Identifiers.xibCellReuseIdentifier)
    }
}

// MARK: - Table view data source and delegate
extension MasterTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Resources.Identifiers.xibCellReuseIdentifier,
                                                 for: indexPath) as! TableViewCell
        
        cell.configure(with: tasks[indexPath.row])
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        delegate?.prepareForAppear(with: tasks[indexPath.row], and: indexPath, sender: self)
        
        if let detailViewController = delegate as? DetailViewController {
            splitViewController?.showDetailViewController(detailViewController, sender: nil)
        }
    }

}


//MARK: - Delegates
extension MasterTableViewController : TableViewCellDelegate {
    func didChangeActivity(_ cell: TableViewCell, isActive: Bool) {
        if let indexPath = tableView.indexPath(for: cell){
            tasks[indexPath.row].isOn = isActive
        }
    }
}

extension MasterTableViewController : NewOrChangedTaskViewControllerDelegate {
    func change(task: Task, on indexPath: IndexPath) {
        self.tasks.remove(at: indexPath.row)
        self.tasks.insert(task, at: indexPath.row)
        self.tableView.reloadData()
    }
    func addNew(task: Task) {
        tasks.append(task)
        self.tableView.reloadData()
    }
}

//MARK: -Create UI
extension MasterTableViewController {
    func createPlusButton() -> UIBarButtonItem{
        let plusButton = UIBarButtonItem(barButtonSystemItem: .add,
                                         target: self,
                                         action: #selector(plusButtonTapped))
        plusButton.tintColor = Resources.Colors.mainThemeColor
        return plusButton
    }
    
    func setNavigatinController(with button: UIBarButtonItem) {
        navigationItem.rightBarButtonItems = [button]
        self.navigationController?.navigationBar.layer.borderColor = Resources.Colors.secondGrayColor.cgColor
        self.navigationController?.navigationBar.layer.borderWidth = 3
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "your_tasks"
    }
    
    @objc func plusButtonTapped() {
        let newTaskVC = NewTaskViewController()
        newTaskVC.view.backgroundColor = self.view.backgroundColor
        newTaskVC.delegate = self
        self.present(newTaskVC, animated: true)
    }
}
