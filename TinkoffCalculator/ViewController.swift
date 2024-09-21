//
//  ViewController.swift
//  TinkoffCalculator
//
//  Created by Egor on 21.09.2024.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func buttonTapped(_ sender: UIButton) {
        guard let text = sender.currentTitle else { return }
        print(text)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

