//
//  DetailViewController.swift
//  lection13(tableView)
//
//  Created by Влад Енбаев on 05.03.2023.
//

import UIKit


class DetailViewController: UIViewController{
    
    var task : Task? {
        didSet {
            loadViewIfNeeded()
            titleTextField.text = task?.title
            descriptionTextView.text = task?.description
        }
    }
    var indexPath : IndexPath!
    
    var descriptionTextView : UITextView!
    var titleTextField : UITextField!
    var doneButton : UIBarButtonItem!
    
    weak var delegate : NewOrChangedTaskViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton = createDoneButton()
        titleTextField = createTitleTextField()
        descriptionTextView = createDescriptionTextView()
        self.view.backgroundColor = UIColor.systemBackground
        self.navigationItem.rightBarButtonItem = doneButton
        self.navigationItem.hidesBackButton = true
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.layer.borderColor = .none
        self.navigationController?.navigationBar.layer.borderWidth = 0
    }
    
}

//MARK: -Create UI
extension DetailViewController {
    func createDoneButton() -> UIBarButtonItem {
        let button = UIBarButtonItem(barButtonSystemItem: .done,
                                     target: self,
                                     action: #selector(doneButtonPressed))
        return button
    }
    
    func createTitleTextField() -> UITextField{
        let titleTextField = UITextField()
        titleTextField.placeholder = "name of task"
        titleTextField.borderStyle = .none
        titleTextField.textAlignment = .center
        titleTextField.layer.borderWidth = 2
        titleTextField.layer.borderColor = UIColor.black.cgColor
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(titleTextField)
        //autolayout
        titleTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        titleTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        titleTextField.heightAnchor.constraint(equalToConstant: 34).isActive = true
        titleTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        return titleTextField
    }
    func createDescriptionTextView() -> UITextView{
        let descriptionTextView = UITextView()
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.layer.borderWidth = 2
        descriptionTextView.layer.borderColor = UIColor.black.cgColor
        descriptionTextView.font = UIFont.systemFont(ofSize: 15)
        descriptionTextView.textColor = .black
        descriptionTextView.delegate = self
        self.view.addSubview(descriptionTextView)
        //autolayout
        descriptionTextView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9)
            .isActive = true
        descriptionTextView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5)
            .isActive = true
        descriptionTextView.centerXAnchor.constraint(equalTo: titleTextField.centerXAnchor)
            .isActive = true
        descriptionTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 60)
            .isActive = true
        //hide keyboard
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTextView(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTextView(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        return descriptionTextView
    }
}
//MARK: - Actions
extension DetailViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.descriptionTextView.resignFirstResponder()
    }
    
    //back to main vc
    @objc func doneButtonPressed(){
        guard let title = titleTextField.text else { return }
        let description = descriptionTextView.text ?? ""
        let changedTask = Task(title: title, description: description, isOn: true)
        if let delegate = self.delegate, let indexPath = self.indexPath{
            delegate.change(task: changedTask, on: indexPath)
        }
        self.navigationController?.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func updateTextView(notification: Notification){
        guard
            let userInfo = notification.userInfo,
            let keyboardRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else { return }
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            descriptionTextView.contentInset = UIEdgeInsets.zero
            descriptionTextView.scrollIndicatorInsets = descriptionTextView.contentInset
        } else {
            descriptionTextView.contentInset = UIEdgeInsets(top: 0,
                                                            left: 0,
                                                            bottom: keyboardRect.height,
                                                            right: 0)
            descriptionTextView.scrollIndicatorInsets = descriptionTextView.contentInset
        }
    }
}

//MARK: -Delegates
extension DetailViewController : UITextViewDelegate {
}

extension DetailViewController : MasterVCDelegate {
    func prepareForAppear(with task: Task, and indexPath: IndexPath, sender: AnyObject) {
        self.delegate = sender as? NewOrChangedTaskViewControllerDelegate
        self.task = task
        self.indexPath = indexPath
    }
}
