//
//  TransactionsViewController.swift
//  PersonalFinanceApp
//
//  Created by Kruti Trivedi on 20/06/24.
//

import UIKit
import CoreData

class TransactionsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    var loadingIndicator: UIActivityIndicatorView?

    var transactions: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setupLoadingIndicator()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTransactions()
    }

    @IBAction func filterButtonTapped(_ sender: UIButton) {
        fetchTransactions()
    }

    func setupLoadingIndicator() {
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator?.center = view.center
        view.addSubview(loadingIndicator!)
    }

    func fetchTransactions() {
        loadingIndicator?.startAnimating()
        let fetchRequestEarnings: NSFetchRequest<Earning> = Earning.fetchRequest()
        let fetchRequestExpenses: NSFetchRequest<Expense> = Expense.fetchRequest()

        let startDate = startDatePicker.date.stripTime()
        let endDate = endDatePicker.date.stripTime()

        fetchRequestEarnings.predicate = NSPredicate(format: "date >= %@ AND date <= %@", startDate as NSDate, endDate as NSDate)
        fetchRequestExpenses.predicate = NSPredicate(format: "date >= %@ AND date <= %@", startDate as NSDate, endDate as NSDate)

        do {
            let earnings = try PersistenceService.context.fetch(fetchRequestEarnings)
            let expenses = try PersistenceService.context.fetch(fetchRequestExpenses)
            transactions = (earnings as [NSManagedObject]) + (expenses as [NSManagedObject])
            transactions.sort { ($0.value(forKey: "date") as! Date) < ($1.value(forKey: "date") as! Date) }
            tableView.reloadData()
            loadingIndicator?.stopAnimating()
        } catch {
            loadingIndicator?.stopAnimating()
            showErrorAlert(error: error)
        }
    }

    func showErrorAlert(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
            self.fetchTransactions()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension TransactionsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath)
        let transaction = transactions[indexPath.row]

        if let earning = transaction as? Earning {
            cell.textLabel?.text = "Earning: \(earning.amount) - \(earning.descriptionText ?? "")"
            cell.detailTextLabel?.text = "\(earning.date ?? Date())"
        } else if let expense = transaction as? Expense {
            cell.textLabel?.text = "Expense: \(expense.amount) - \(expense.descriptionText ?? "")"
            cell.detailTextLabel?.text = "\(expense.date ?? Date())"
        }
        return cell
    }
}

