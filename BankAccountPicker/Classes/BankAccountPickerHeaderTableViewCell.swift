//
//  BillPickerHeaderTableViewCell.swift
//  BankAccountPicker
//
//  Created by Sherzod Khashimov on 7/4/18.
//

import UIKit

/// Bank Account  Picker Header.
class BankAccountPickerHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    var theme: BankAccountPickerTheme = DefaultBankAccountPickerTheme()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(name: String, description: String, theme: BankAccountPickerTheme) {
        nameLabel.text = name
        nameLabel.textColor = theme.pickerNameTextColor
        descriptionLabel.text = description
        descriptionLabel.textColor = theme.pickerDescriptionTextColor
    }

}
