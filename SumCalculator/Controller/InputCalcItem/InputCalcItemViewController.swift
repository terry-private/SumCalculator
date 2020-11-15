//
//  InputCalcItemViewController.swift
//  SumCalculator
//
//  Created by 若江照仁 on 2020/11/15.
//

import UIKit

class InputCalcItemViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "詳細情報"

        // Do any additional setup after loading the view.
    }
    @IBAction func itemNameEdited(_ sender: Any) {
        view.endEditing(true)
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
