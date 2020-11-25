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
        closeButton.tintColor = .label
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
        let storyboard = UIStoryboard(name: "TemplateTableList", bundle: nil)
        let templateTableListViewController = storyboard.instantiateViewController(identifier: "TemplateTableListViewController") as! TemplateTableListViewController
        templateTableListViewController.navigationItem.title = "リストテンプレート"
        templateTableListViewController.templateType = .Table
        let nav = UINavigationController(rootViewController: templateTableListViewController)
        //nav.navigationBar.barTintColor = .cyan
        nav.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.label, .font:UIFont(name: "PingFangHK-Thin", size: 18)!]
        nav.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.label, .font:UIFont(name: "PingFangHK-Thin", size: 22)!]
        nav.navigationBar.prefersLargeTitles = true
        nav.modalPresentationStyle = .fullScreen
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .push
        transition.subtype = .fromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(nav,animated: false, completion: nil)
    }
    @IBAction func tappedTemplateItemButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "TemplateItemFolderList", bundle: nil)
        let templateTableListViewController = storyboard.instantiateViewController(identifier: "TemplateItemFolderListViewController") as! TemplateItemFolderListViewController
        templateTableListViewController.navigationItem.title = "項目テンプレートのフォルダ"
        let nav = UINavigationController(rootViewController: templateTableListViewController)
        //nav.navigationBar.barTintColor = .cyan
        nav.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.label, .font:UIFont(name: "PingFangHK-Thin", size: 18)!]
        nav.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.label, .font:UIFont(name: "PingFangHK-Thin", size: 22)!]
        nav.navigationBar.prefersLargeTitles = true
        nav.modalPresentationStyle = .fullScreen
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .push
        transition.subtype = .fromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(nav,animated: false, completion: nil)
    }
    

}
