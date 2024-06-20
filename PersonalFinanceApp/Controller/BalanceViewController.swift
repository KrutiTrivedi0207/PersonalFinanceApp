//
//  BalanceViewController.swift
//  PersonalFinanceApp
//
//  Created by Kruti Trivedi on 20/06/24.
//

import UIKit
import CoreData

class BalanceViewController: UIViewController, BalanceUpdateDelegate {

    @IBOutlet weak var balanceLabel: UILabel!
    var loadingIndicator: UIActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateBalance()
    }

    func setupLoadingIndicator() {
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator?.center = view.center
        view.addSubview(loadingIndicator!)
    }

    func didUpdateBalance() {
        updateBalance()
    }

    func updateBalance() {
        loadingIndicator?.startAnimating()
        let earningsFetchRequest: NSFetchRequest<Earning> = Earning.fetchRequest()
        let expensesFetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        do {
            let earnings = try PersistenceService.context.fetch(earningsFetchRequest)
            let expenses = try PersistenceService.context.fetch(expensesFetchRequest)
            let totalEarnings = earnings.reduce(0) { $0 + $1.amount }
            let totalExpenses = expenses.reduce(0) { $0 + $1.amount }
            let balance = totalEarnings - totalExpenses
            balanceLabel.text = "Current Balance: \(balance)"
            loadingIndicator?.stopAnimating()
        } catch {
            print("Failed to fetch earnings or expenses: \(error)")
            loadingIndicator?.stopAnimating()
        }
    }
}

