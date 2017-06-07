//
//  MapSettingsTableViewCell.swift
//  YelpGMaps
//
//  Created by Alexey Danilov on 06.06.17.
//  Copyright © 2017 iPoint. All rights reserved.
//

import UIKit
import GoogleMaps

class MapSettingsTableViewCell: UITableViewCell {
    
    var settings: Settings! {
        didSet {
            self.termTextField.text = GlobalConstants.TERM_OPTIONS[self.settings.term]
            self.updateMapSwitcher.setOn(self.settings.updateOnMapChanges, animated: true)
            self.mapScaleSlider.setValue(Float(self.settings.scale), animated: true)
            self.entityCountSlider.setValue(Float(self.settings.entityCount), animated: true)
        }
    }
    
    let termKeys: Array<String> = Array(GlobalConstants.TERM_OPTIONS.keys)
    
    var termValues: Array<String> = Array(GlobalConstants.TERM_OPTIONS.values)
    
    let pickerView = UIPickerView()
    
    var newSelectedTerm: (key: String, value: String)!
    
    @IBOutlet weak var resetToDefaultsButton: CustomButton!
    
    @IBOutlet weak var termTextField: UITextField!
    
    @IBOutlet weak var entityCountSlider: UISlider!
    
    @IBOutlet weak var mapScaleSlider: UISlider!
    
    @IBOutlet weak var updateMapSwitcher: UISwitch!
    
    @IBOutlet weak var entityCountMinLabel: UILabel!
    
    @IBOutlet weak var entityCountMaxLabel: UILabel!
    
    @IBOutlet weak var scaleMinLabel: UILabel!
    
    @IBOutlet weak var scaleMaxLabel: UILabel!
    
    @IBOutlet weak var entityCountContainerView: CustomView!
    
    @IBOutlet weak var scaleContainerView: CustomView!
    
    
    
    @IBAction func resetButtonTapped(_ sender: Any) {
        self.settings = Settings()
        self.updateStoredSettings()
    }
    
    override func awakeFromNib() {
        
        self.resetToDefaultsButton.borderColor = GlobalConstants.Color.primaryDark!.cgColor
        self.resetToDefaultsButton.setTitleColor(GlobalConstants.Color.primaryDark!, for: .normal)
        
        self.entityCountContainerView.borderColor = GlobalConstants.Color.secondaryDark!.cgColor
        
        self.scaleContainerView.borderColor = GlobalConstants.Color.secondaryDark!.cgColor
        
        self.scaleMinLabel.text = String(format: "%g", kGMSMinZoomLevel)
        self.scaleMaxLabel.text = String(format: "%g", kGMSMaxZoomLevel)
        self.mapScaleSlider.minimumValue = kGMSMinZoomLevel
        self.mapScaleSlider.maximumValue = kGMSMaxZoomLevel
        self.mapScaleSlider.thumbTintColor = GlobalConstants.Color.primaryDark
        self.mapScaleSlider.tintColor = GlobalConstants.Color.primaryDark
        
        self.entityCountMinLabel.text = "\(20)"
        self.entityCountMaxLabel.text = "\(50)"
        self.entityCountSlider.minimumValue = 20
        self.entityCountSlider.maximumValue = 50
        self.entityCountSlider.thumbTintColor = GlobalConstants.Color.primaryDark
        self.entityCountSlider.tintColor = GlobalConstants.Color.primaryDark
        
        self.updateMapSwitcher.onTintColor = GlobalConstants.Color.primaryDark
        self.updateMapSwitcher.tintColor = GlobalConstants.Color.primaryLight
        
        self.settings = CurrentValues.currentSettings
        
        self.configurePickerView()
    }
    
    @IBAction func scaleSliderChanged(_ sender: Any) {
        self.settings.scale = Double(self.mapScaleSlider.value)
        self.updateStoredSettings()
    }
    
    func updateStoredSettings() {
        let ud = UserDefaults.standard
        CurrentValues.currentSettings = self.settings
        CurrentValues.isDataNeedToReload = true
        let endodedData = NSKeyedArchiver.archivedData(withRootObject: self.settings)
        ud.set(endodedData, forKey: "stored_settings")
        ud.synchronize()
    }
    
    @IBAction func updateMapSwitcherChanged(_ sender: Any) {
        self.settings.updateOnMapChanges = self.updateMapSwitcher.isOn
        self.updateStoredSettings()
    }
    
    @IBAction func entityCountSliderChanged(_ sender: Any) {
        self.settings.entityCount = Int(self.entityCountSlider.value)
        self.updateStoredSettings()
    }
    
    func configurePickerView() {
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.showsSelectionIndicator = true
        
        self.termTextField.inputView = self.pickerView
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(MapSettingsTableViewCell.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(MapSettingsTableViewCell.cancelPicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.termTextField.inputAccessoryView = toolBar
        if let index = self.termKeys.index(of: self.settings.term) {
            self.pickerView.selectRow(index, inComponent: 0, animated: false)
        }
        
    }
    
    func donePicker() {
        if self.newSelectedTerm != nil {
            self.settings.term = self.newSelectedTerm.key
            self.termTextField.text = self.newSelectedTerm.value
            self.updateStoredSettings()
        }
        self.contentView.endEditing(true)
    }
    
    func cancelPicker() {
        self.contentView.endEditing(true)
    }
    
}

extension MapSettingsTableViewCell: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.newSelectedTerm = (key: self.termKeys[row], value: self.termValues[row])
    }
}

extension MapSettingsTableViewCell: UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return GlobalConstants.TERM_OPTIONS.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.termValues[row]
    }
    
}
