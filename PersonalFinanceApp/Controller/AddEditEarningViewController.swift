//
//  AddEditEarningViewController.swift
//  PersonalFinanceApp
//
//  Created by Kruti Trivedi on 20/06/24.
//

import UIKit
import CoreData

protocol AddEditEarningDelegate: AnyObject {
    func didSaveEarning()
}

class AddEditEarningViewController: UIViewController {

    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!

    var earning: Earning?
    weak var delegate: AddEditEarningDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTextField.text = "Enter description"
        descriptionTextField.textColor = UIColor.lightGray
        descriptionTextField.delegate = self
        descriptionTextField.layer.borderWidth = 1
        descriptionTextField.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
        descriptionTextField.layer.cornerRadius = 6
        descriptionTextField.clipsToBounds = true
        
        if let earning = earning {
            amountTextField.text = "\(earning.amount)"
            if (earning.descriptionText?.count ?? 0) > 0 {
                descriptionTextField.textColor = UIColor.black
            }
            descriptionTextField.text = earning.descriptionText
            if let date = earning.date {
                datePicker.date = date
            }
        }
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let amountText = amountTextField.text, let amount = Double(amountText),
              let description = descriptionTextField.text else { return }

        let date = datePicker.date

        if let earning = earning {
            earning.amount = amount
            earning.descriptionText = description
            earning.date = date.stripTime()
        } else {
            let newEarning = Earning(context: PersistenceService.context)
            newEarning.amount = amount
            newEarning.descriptionText = description
            newEarning.date = date.stripTime()
        }

        PersistenceService.saveContext()
        delegate?.didSaveEarning()
        navigationController?.popViewController(animated: true)
    }
}

//MARK: TextView Delegate

extension AddEditEarningViewController: UITextViewDelegate {
    
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
