//
//  newТaskViewController.swift
//  lection13(tableView)
//
//  Created by Влад Енбаев on 06.03.2023.
//

import UIKit

class NewTaskViewController: UIViewController {
    
    var descriptionTextView : UITextView!
    var titleTextField : UITextField!
    var doneButton : UIBarButtonItem!
    var navigationBar : UINavigationBar!
    
    var task : Task?
    
    weak var delegate : NewOrChangedTaskViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton = createDoneButton()
        navigationBar = createNavigationBar(with: doneButton)
        titleTextField = createTitleTextField()
        descriptionTextView = createDescriptionTextView()
    }
}
//MARK: - Create UI
extension NewTaskViewController {
    
    func createNavigationBar(with button: UIBarButtonItem) -> UINavigationBar{
        let navigationBar = UINavigationBar()
        let navigationItem = UINavigationItem(title: "create new task")
        navigationItem.rightBarButtonItem = button
        navigationBar.items = [navigationItem]
        navigationBar.backgroundColor = .none
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(navigationBar)
        // autolayout
        navigationBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        navigationBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        navigationBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        return navigationBar
    }
    
    func createDoneButton() -> UIBarButtonItem{
        let button = UIBarButtonItem(barButtonSystemItem: .done,
                                     target: self,
                                     action: #selector(doneButtonPressed))
        return button
    }
    
    func createTitleTextField() -> UITextField{
        let titleTextField = UITextField()
        titleTextField.placeholder = " name of new task "
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
        titleTextField.topAnchor.constraint(equalTo: self.navigationBar.bottomAnchor, constant: 20).isActive = true
        return titleTextField
    }
    func createDescriptionTextView() -> UITextView{
        let descriptionTextView = UITextView()
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.layer.borderWidth = 2
        descriptionTextView.layer.borderColor = UIColor.black.cgColor
        descriptionTextView.font = UIFont.systemFont(ofSize: 15)
        descriptionTextView.text = "describe your task"
        descriptionTextView.textColor = .gray
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
extension NewTaskViewController {
    @objc func doneButtonPressed(){
        guard let title = titleTextField.text else { return }
        if !title.isEmpty {
            let description = descriptionTextView.text ?? ""
            let newTask = Task(title: title, description: description, isOn: true)
            if let delegate = self.delegate{
                delegate.addNew(task: newTask)
            }
            self.dismiss(animated: true)
        }
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.descriptionTextView.resignFirstResponder()
    }
}


//MARK: - Delegates
extension NewTaskViewController : UITextViewDelegate{
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.backgroundColor = .white
        textView.text = ""
        textView.textColor = .black
        return true
    }
}
