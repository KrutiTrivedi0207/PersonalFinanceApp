//
//  DashboardViewController.swift
//  PersonalFinanceApp
//
//  Created by Kruti Trivedi on 20/06/24.
//

import UIKit
import GoogleSignIn

class DashboardViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
    }
    
    func setupViewControllers() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let profileVC = mainStoryboard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController,
              let earningsVC = mainStoryboard.instantiateViewController(withIdentifier: "EarningsViewController") as? EarningsViewController,
              let expensesVC = mainStoryboard.instantiateViewController(withIdentifier: "ExpensesViewController") as? ExpensesViewController,
              let balanceVC = mainStoryboard.instantiateViewController(withIdentifier: "BalanceViewController") as? BalanceViewController,
              let transactionsVC = mainStoryboard.instantiateViewController(withIdentifier: "TransactionsViewController") as? TransactionsViewController,
              let newsVC = mainStoryboard.instantiateViewController(withIdentifier: "NewsListViewController") as? NewsListViewController else {
            return
        }
        
        let profileNav = UINavigationController(rootViewController: profileVC)
        profileNav.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 0)
        
        let earningsNav = UINavigationController(rootViewController: earningsVC)
        earningsNav.tabBarItem = UITabBarItem(title: "Earnings", image: UIImage(systemName: "plus.circle"), tag: 1)
        
        let expensesNav = UINavigationController(rootViewController: expensesVC)
        expensesNav.tabBarItem = UITabBarItem(title: "Expenses", image: UIImage(systemName: "minus.circle"), tag: 2)
        
        let balanceNav = UINavigationController(rootViewController: balanceVC)
        balanceNav.tabBarItem = UITabBarItem(title: "Balance", image: UIImage(systemName: "dollarsign.circle"), tag: 3)
        
        let transactionsNav = UINavigationController(rootViewController: transactionsVC)
        transactionsNav.tabBarItem = UITabBarItem(title: "Transactions", image: UIImage(systemName: "list.bullet"), tag: 4)
        
        let newsNav = UINavigationController(rootViewController: newsVC)
        newsNav.tabBarItem = UITabBarItem(title: "News", image: UIImage(systemName: "newspaper"), tag: 5)
        
        self.viewControllers = [profileNav, earningsNav, expensesNav, balanceNav, transactionsNav, newsNav]
    }

}
