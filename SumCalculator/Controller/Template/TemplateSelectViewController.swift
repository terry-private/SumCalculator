//
//  TemplateSelectViewController.swift
//  SumCalculator
//
//  Created by 若江照仁 on 2020/11/22.
//

import UIKit

class TemplateSelectViewController: UIViewController {
    // -------------------------------------------------
    // IBOutlet
    // -------------------------------------------------
    @IBOutlet weak var listTemplateButton: UIButton!
    @IBOutlet weak var itemTemplateButton: UIButton!
    
    // -------------------------------------------------
    // ライフサイクル
    // -------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        setButton()
        let closeButton = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(close))
        navigationItem.leftBarButtonItem = closeButton
        // Do any additional setup after loading the view.
    }
    
    func setButton() {
        listTemplateButton.layer.cornerRadius = 8
        listTemplateButton.layer.borderWidth = 0.5
        listTemplateButton.layer.borderColor = UIColor.systemGray3.cgColor
        itemTemplateButton.layer.cornerRadius = 8
        itemTemplateButton.layer.borderWidth = 0.5
        itemTemplateButton.layer.borderColor = UIColor.systemGray3.cgColor
    }
    
    // -------------------------------------------------
    // @objc
    // -------------------------------------------------
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedTemplateListButton(_ sender: Any) {
        
    }
    @IBAction func tappedTemplateItemButton(_ sender: Any) {
    }
    

}
