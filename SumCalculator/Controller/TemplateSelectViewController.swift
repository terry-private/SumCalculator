//
//  TemplateSelectViewController.swift
//  SumCalculator
//
//  Created by 若江照仁 on 2020/11/22.
//

import UIKit

class TemplateSelectViewController: UIViewController {
    @IBOutlet weak var listTemplateButton: UIButton!
    @IBOutlet weak var itemTemplateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem?.title = "キャンセル"
        setButton()
        // Do any additional setup after loading the view.
    }
    
    func setButton() {
        let closeButton = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(close))
        navigationItem.leftBarButtonItem = closeButton
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
