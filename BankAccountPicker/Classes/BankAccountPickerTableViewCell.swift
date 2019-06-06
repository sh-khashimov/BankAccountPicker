//
//  BillPickerTableViewCell.swift
//  BankAccountPicker
//
//  Created by Sherzod Khashimov on 7/4/18.
//

import UIKit

/// Bank Account Cell.
class BankAccountPickerTableViewCell: UITableViewCell {

    @IBOutlet weak var bankAccountNameLabel: UILabel!
    @IBOutlet weak var bankAccountLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var checkIconImageView: UIImageView!
    @IBOutlet weak var viewLeadingLC: NSLayoutConstraint!
    @IBOutlet weak var accountLeadingLC: NSLayoutConstraint!

    var theme: BankAccountPickerTheme = DefaultBankAccountPickerTheme()

    var bankAccount: BankAccountPickerItem? {
        didSet {
            bankAccountNameLabel.text = self.bankAccount?.accountName ?? ""
            bankAccountNameLabel.textColor = theme.bankAccountNameTextColor
            bankAccountLabel.text = self.bankAccount?.account ?? ""
            bankAccountLabel.textColor = theme.bankAccountTextColor

            if let currency = self.bankAccount?.currency, let balance = self.bankAccount?.balance {

                let labelColor = balance > 0 ? theme.balancePositiveColor : theme.balanceNegativeColor

                let balanceString = String(format: "%.0f", balance)

                let attributedString = NSMutableAttributedString(string: "\(balanceString) \(currency.uppercased())", attributes: [
                    .font: UIFont.systemFont(ofSize: 14.0, weight: .medium),
                    .foregroundColor: labelColor
                    ])
                attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 10, weight: .medium),
                                              range: NSRange(location: balanceString.count+1, length: currency.count))

                balanceLabel.attributedText = attributedString
            } else {
                if let balance = self.bankAccount?.balance {
                    balanceLabel.text = String(format: "%.0f", balance)
                } else {
                    balanceLabel.text = ""
                }
            }

            if self.bankAccount?.isSelected ?? false {
                self.contentView.backgroundColor = theme.selectedBankAccountBackgroundColor
            } else {
                self.contentView.backgroundColor = .white
            }

            checkIconImageView.isHidden = !(self.bankAccount?.isSelected ?? false)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(_ item: (bankAccount: BankAccountPickerItem?, parentHasSelectedItem: Bool, theme: BankAccountPickerTheme)) {
        self.theme = item.theme
        self.bankAccount = item.bankAccount
        if item.parentHasSelectedItem {
            viewLeadingLC.constant = 47
            accountLeadingLC.constant = 47
        } else {
            viewLeadingLC.constant = 16
            accountLeadingLC.constant = 16
        }
    }

}
