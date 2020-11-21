//
//  InputNewNameViewController.swift
//  SumCalculator
//
//  Created by 若江照仁 on 2020/11/15.
//

import UIKit

protocol InputNewNameDelegate: class {
    func addNew(name: String)
}

class InputNewNameViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    weak var delegate: InputNewNameDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmButton.layer.cornerRadius = 8
        confirmButton.layer.borderWidth = 0.5
        confirmButton.layer.borderColor = UIColor.opaqueSeparator.cgColor
    }
    @IBAction func tappedConfirmButton(_ sender: Any) {
        delegate?.addNew(name: nameTextField.text ?? "")
        dismiss(animated: true, completion: nil)
    }
}

