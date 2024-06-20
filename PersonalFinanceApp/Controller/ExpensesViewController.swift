//
//  ExpensesViewController.swift
//  PersonalFinanceApp
//
//  Created by Kruti Trivedi on 20/06/24.
//

import UIKit
import CoreData

class ExpensesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblInfo: UILabel!
    weak var delegate: BalanceUpdateDelegate?
    var expenses: [Expense] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchExpenses()
    }

    func fetchExpenses() {
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        do {
            expenses = try PersistenceService.context.fetch(fetchRequest)
            if expenses.count > 0 {
                lblInfo.isHidden = false
            }else {
                lblInfo.isHidden = true
            }
            tableView.reloadData()
        } catch {
            lblInfo.isHidden = true
            print("Failed to fetch expenses: \(error)")
        }
    }

    @IBAction func addExpenseButtonTapped(_ sender: UIBarButtonItem) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let addEditExpenseVC = mainStoryboard.instantiateViewController(withIdentifier: "AddEditExpenseViewController") as? AddEditExpenseViewController {
            addEditExpenseVC.delegate = self
            navigationController?.pushViewController(addEditExpenseVC, animated: true)
        }
    }
}

extension ExpensesViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCell", for: indexPath)
        let expense = expenses[indexPath.row]
        cell.selectionStyle = .none
        cell.textLabel?.text = "\(expense.amount) - \(expense.descriptionText ?? "")"
        cell.detailTextLabel?.text = "\(expense.date ?? Date())"
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let expense = expenses[indexPath.row]
            deleteExpense(expense: expense)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let expense = expenses[indexPath.row]
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let addEditExpenseVC = mainStoryboard.instantiateViewController(withIdentifier: "AddEditExpenseViewController") as? AddEditExpenseViewController {
            addEditExpenseVC.expense = expense
            addEditExpenseVC.delegate = self
            navigationController?.pushViewController(addEditExpenseVC, animated: true)
        }
    }

    func deleteExpense(expense: Expense) {
        PersistenceService.context.delete(expense)
        PersistenceService.saveContext()
        fetchExpenses()
        delegate?.didUpdateBalance()
    }
}

extension ExpensesViewController: AddEditExpenseDelegate {
    func didSaveExpense() {
        fetchExpenses()
        delegate?.didUpdateBalance()
    }
}

