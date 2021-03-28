//
//  AboutController.swift
//  MyCheeseOrNothing
//
//  Created by Emerick CHALET on 24/03/2021.
//

import UIKit

class AboutController: UIViewController {
   
   let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
   
    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated);
    }
    
    override func viewDidLoad() {
       super.viewDidLoad()

        versionLabel.text = "Version v\(version!)"
   }
}
