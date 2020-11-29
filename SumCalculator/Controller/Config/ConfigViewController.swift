//
//  ConfigViewController.swift
//  SumCalculator
//
//  Created by 若江照仁 on 2020/11/25.
//

import UIKit

class ConfigViewController: UIViewController {
    @IBOutlet weak var unitPriceSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var quantitySegmentedControl: UISegmentedControl!
    @IBOutlet weak var totalSegmentedControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSegmentedControl()
        let closeButton = UIBarButtonItem(title: "戻る", style: .plain, target: self, action: #selector(close))
        navigationItem.leftBarButtonItem = closeButton
        // Do any additional setup after loading the view.
    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(<#T##animated: Bool##Bool#>)
//        setSegmentedControl()
//    }
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    
    func setSegmentedControl() {
        let userConfig = UserConfig()
        unitPriceSegmentedControl.selectedSegmentIndex = userConfig.unitCurrencyFractionalDigit
        quantitySegmentedControl.selectedSegmentIndex = userConfig.quantityFractionalDigit
        totalSegmentedControl.selectedSegmentIndex = userConfig.totalCurrencyFractionalDigit
    }
    @IBAction func tappedUnitPriceSegmentedControl(_ sender: Any) {
        let userConfig = UserConfig()
        userConfig.unitCurrencyFractionalDigit = unitPriceSegmentedControl.selectedSegmentIndex
    }
    @IBAction func tappedQuantitySegmentedControl(_ sender: Any) {
        let userConfig = UserConfig()
        userConfig.quantityFractionalDigit = quantitySegmentedControl.selectedSegmentIndex
    }
    @IBAction func tappedTotalSegmentedControl(_ sender: Any) {
        let userConfig = UserConfig()
        userConfig.totalCurrencyFractionalDigit = totalSegmentedControl.selectedSegmentIndex
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
