//
//  ProfileViewController.swift
//  PersonalFinanceApp
//
//  Created by Kruti Trivedi on 20/06/24.
//

import UIKit
import GoogleSignIn
import CoreData

class ProfileViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    var userName: String?
    var userEmail: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = UserDefaults.standard.value(forKey: "userName") as? String ?? ""
        emailLabel.text = UserDefaults.standard.value(forKey: "userEmail") as? String ?? ""
    }

    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        GIDSignIn.sharedInstance.signOut()
        UserDefaults.standard.removeObject(forKey: "userName")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        deleteAllData()
        AppDelegate().sharedInstance().goto(isLogin: false)
    }
    
    func deleteAllData() {
        let entities = ["Earning", "Expense"] // Replace with your actual entity names
        
        for entityName in entities {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try PersistenceService.context.execute(deleteRequest)
                PersistenceService.saveContext()
            } catch let error as NSError {
                print("Could not delete data from \(entityName). \(error), \(error.userInfo)")
            }
        }
    }
}

