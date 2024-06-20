//
//  EarningsViewController.swift
//  PersonalFinanceApp
//
//  Created by Kruti Trivedi on 20/06/24.
//

import UIKit
import CoreData

protocol BalanceUpdateDelegate: AnyObject {
    func didUpdateBalance()
}

class EarningsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblInfo: UILabel!
    weak var delegate: BalanceUpdateDelegate?
    var earnings: [Earning] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchEarnings()
    }

    func fetchEarnings() {
        let fetchRequest: NSFetchRequest<Earning> = Earning.fetchRequest()
        do {
            earnings = try PersistenceService.context.fetch(fetchRequest)
            if earnings.count > 0 {
                lblInfo.isHidden = false
            }else {
                lblInfo.isHidden = true
            }
            tableView.reloadData()
        } catch {
            lblInfo.isHidden = true
            print("Failed to fetch earnings: \(error)")
        }
    }

    @IBAction func addEarningButtonTapped(_ sender: UIBarButtonItem) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let addEditEarningVC = mainStoryboard.instantiateViewController(withIdentifier: "AddEditEarningViewController") as? AddEditEarningViewController {
            addEditEarningVC.delegate = self
            navigationController?.pushViewController(addEditEarningVC, animated: true)
        }
    }
}

extension EarningsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return earnings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EarningCell", for: indexPath)
        let earning = earnings[indexPath.row]
        cell.selectionStyle = .none
        cell.textLabel?.text = "\(earning.amount) - \(earning.descriptionText ?? "")"
        cell.detailTextLabel?.text = "\(earning.date ?? Date())"
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let earning = earnings[indexPath.row]
            deleteEarning(earning: earning)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let earning = earnings[indexPath.row]
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let addEditEarningVC = mainStoryboard.instantiateViewController(withIdentifier: "AddEditEarningViewController") as? AddEditEarningViewController {
            addEditEarningVC.earning = earning
            addEditEarningVC.delegate = self
            navigationController?.pushViewController(addEditEarningVC, animated: true)
        }
    }

    func deleteEarning(earning: Earning) {
        PersistenceService.context.delete(earning)
        PersistenceService.saveContext()
        fetchEarnings()
        delegate?.didUpdateBalance()
    }
}

extension EarningsViewController: AddEditEarningDelegate {
    func didSaveEarning() {
        fetchEarnings()
        delegate?.didUpdateBalance()
    }
}


