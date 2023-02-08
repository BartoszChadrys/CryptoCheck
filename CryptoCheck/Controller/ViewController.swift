//
//  ViewController.swift
//  CryptoCheck
//
//  Created by Bartek Chadryś on 07/02/2023.
//

import UIKit
import CLTypingLabel

class ViewController: UIViewController {
    
    @IBOutlet weak var animatedGif: UIImageView!
    @IBOutlet weak var cryptoCheckLabel: CLTypingLabel!
    @IBOutlet weak var cryptoLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    
    @IBOutlet weak var cryptoPicker: UIPickerView!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cryptoCheckLabel.text = "Crypto Check"
        
        cryptoPicker.dataSource = self
        cryptoPicker.delegate = self
        
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        
        coinManager.delegate = self
        coinManager.getCoinRate()
    }
}
    
//MARK: - UIPickerViewDelegate
    
    extension ViewController : UIPickerViewDelegate, UIPickerViewDataSource {
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            if pickerView == cryptoPicker {
                return coinManager.cryptoArray.count
            }
            else {
                return coinManager.currencyArray.count
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            if pickerView == cryptoPicker {
                return coinManager.cryptoArray[row]
            }
            else {
                return coinManager.currencyArray[row]
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            if pickerView == cryptoPicker {
                coinManager.selectedCrypto = coinManager.cryptoArray[row]
            }
            else {
                coinManager.selectedCurrency = coinManager.currencyArray[row]
            }
            coinManager.getCoinRate()
        }
    }

//MARK: - CoinManagerDelegate

extension ViewController : CoinManagerDelegate {
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func updateCurrency(coinManager: CoinManager, coinJson: CoinJson) {
        DispatchQueue.main.async {
            self.cryptoLabel.text = coinJson.asset_id_base
            self.currencyLabel.text = coinJson.asset_id_quote
            self.rateLabel.text = String(format: "%.2f", coinJson.rate)
        }
    }
}
    

