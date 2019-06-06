//
//  ViewController.swift
//  BankAccountPicker
//
//  Created by Sherzod Khashimov on 06/06/2019.
//  Copyright (c) 2019 Sherzod Khashimov. All rights reserved.
//

import UIKit
import BankAccountPicker

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func show(_ sender: Any) {

        let bankAccountPickerItems: [BankAccountPickerItem] =
            [BankAccountPickerItem(accountName: "Main account", account: "US00000000000000000001", balance: 2000000, currency: "USD", isSelected: true),
             BankAccountPickerItem(accountName: "Credit account", account: "EU00000000000000000002", balance: 21230, currency: "EUR"),
             BankAccountPickerItem(accountName: "Savings account", account: "RU00000000000000000003", balance: 0, currency: "RUB", isSelected: true),
             BankAccountPickerItem(accountName: "Card account", account: "US00000000000000000004", balance: -20, currency: "USD")]

        let bankAccountPickerViewController: BankAccountPickerViewController =
            BankAccountPickerViewController(name: "My Bank Accounts",
                                            description: "Accounts count: \(bankAccountPickerItems.count)",
                bankAccounts: bankAccountPickerItems)

        bankAccountPickerViewController.selection = { (selectedItem, selectedIndex) in
            print("selected account: \(selectedItem) at index: \(selectedIndex)")
        }

        self.present(bankAccountPickerViewController, animated: true, completion: nil)
    }

    @IBAction func show2(_ sender: Any) {

        let bankAccountPickerItems: [BankAccountPickerItem] =
            [BankAccountPickerItem(accountName: "Main account", account: "US00000000000000000001", balance: 2000000, currency: "USD"),
             BankAccountPickerItem(accountName: "Credit account", account: "EU00000000000000000002", balance: 21230, currency: "EUR"),
             BankAccountPickerItem(accountName: "Savings account", account: "RU00000000000000000003", balance: 0, currency: "RUB"),
             BankAccountPickerItem(accountName: "Card account", account: "US00000000000000000004", balance: -20, currency: "USD")]

        let bankAccountPickerViewController: BankAccountPickerViewController =
            BankAccountPickerViewController(name: "My Bank Accounts",
                                            description: "Accounts count: \(bankAccountPickerItems.count)",
                bankAccounts: bankAccountPickerItems)

        bankAccountPickerViewController.selection = { (selectedItem, selectedIndex) in
            print("selected account: \(selectedItem) at index: \(selectedIndex)")
        }

        self.present(bankAccountPickerViewController, animated: true, completion: nil)
    }

}

