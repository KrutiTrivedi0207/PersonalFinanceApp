//
//  AddEditExpenseViewController.swift
//  PersonalFinanceApp
//
//  Created by Kruti Trivedi on 20/06/24.
//

import UIKit
import CoreData

protocol AddEditExpenseDelegate: AnyObject {
    func didSaveExpense()
}

class AddEditExpenseViewController: UIViewController {

    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!

    var expense: Expense?
    weak var delegate: AddEditExpenseDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTextField.text = "Enter description"
        descriptionTextField.textColor = UIColor.lightGray
        descriptionTextField.delegate = self
        descriptionTextField.layer.borderWidth = 1
        descriptionTextField.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
        descriptionTextField.layer.cornerRadius = 6
        descriptionTextField.clipsToBounds = true
        
        if let expense = expense {
            amountTextField.text = "\(expense.amount)"
            if (expense.descriptionText?.count ?? 0) > 0 {
                descriptionTextField.textColor = UIColor.black
            }
            descriptionTextField.text = expense.descriptionText
            if let date = expense.date {
                datePicker.date = date
            }
        }
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let amountText = amountTextField.text, let amount = Double(amountText),
              let description = descriptionTextField.text else { return }

        let date = datePicker.date

        if let expense = expense {
            expense.amount = amount
            expense.descriptionText = description
            expense.date = date.stripTime()
        } else {
            let newExpense = Expense(context: PersistenceService.context)
            newExpense.amount = amount
            newExpense.descriptionText = description
            newExpense.date = date.stripTime()
        }

        PersistenceService.saveContext()
        delegate?.didSaveExpense()
        navigationController?.popViewController(animated: true)
    }
}

//MARK: TextView Delegate

extension AddEditExpenseViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter description"
            textView.textColor = UIColor.lightGray
        }
    }
    
}
