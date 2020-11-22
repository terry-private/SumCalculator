//
//  InputNewNameViewController.swift
//  SumCalculator
//
//  Created by 若江照仁 on 2020/11/15.
//

import UIKit

protocol InputNewNameDelegate: class {
    func addNew(name: String)
    func upDate(name: String)
}

class InputNewNameViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    weak var delegate: InputNewNameDelegate?
    var originName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmButton.layer.cornerRadius = 8
        confirmButton.layer.borderWidth = 0.5
        confirmButton.layer.borderColor = UIColor.opaqueSeparator.cgColor
        nameTextField.text = originName
    }
    @IBAction func tappedConfirmButton(_ sender: Any) {
        if originName == "" {
            delegate?.addNew(name: nameTextField.text ?? "")
        } else {
            delegate?.upDate(name: nameTextField.text ?? "")
        }
        dismiss(animated: true, completion: nil)
    }
}

