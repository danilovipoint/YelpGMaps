//
//  SettingsViewController.swift
//  YelpGMaps
//
//  Created by Alexey Danilov on 31.05.17.
//  Copyright © 2017 iPoint. All rights reserved.
//

import UIKit

class SettingsViewController: ParentViewController {
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureTableView()
    }
    
    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingsTableViewCell")
        self.tableView.register(UINib(nibName: "MapSettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "MapSettingsTableViewCell")
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 1000
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MapSettingsTableViewCell", for: indexPath) as! MapSettingsTableViewCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as! SettingsTableViewCell
            
            switch (indexPath.row) {
            case 0:
                let iconImage = UIImage(named: "ic_info_outline_48pt")
                cell.iconImageView.image = iconImage
                cell.titleLabel.text = "About"
            default:
                break
            }
            
            return cell
            
        default:
            return UITableViewCell()
        }
        
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Map Settings"
        case 1:
            return "Information"
        default:
            return ""
        }
    }
    
}

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                tableView.deselectRow(at: indexPath, animated: true)
                self.performSegue(withIdentifier: "ShowAbout", sender: self)
            }
        }
    }
}
