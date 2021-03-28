//
//  PopUpController.swift
//  MyCheeseOrNothing
//
//  Created by Emerick CHALET on 24/03/2021.
//


import UIKit

class PopUpController: UIViewController {
   
    @IBOutlet var Buttons: [UIButton]!
    
    override func viewDidLoad() {
       super.viewDidLoad()
   }
    
    @IBAction func levelChoose(_ sender: UIButton) {
        let levelChoose:String? = LevelChoose(sender)
        let app = UIApplication.shared.delegate as! AppDelegate;
        let questionCollection = app.questionCollection;
        
        switch levelChoose {
        case "Facile":
            questionCollection.fetchQuestions(mode: .EASY);
        case "Moyenne":
            questionCollection.fetchQuestions(mode: .MEDIUM);
        case "Difficile":
            questionCollection.fetchQuestions(mode: .HARD);
        case "Aléatoire":
            questionCollection.fetchQuestions(mode: .RANDOM);
        default:
            questionCollection.fetchQuestions(mode: .ALL);
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func LevelChoose(_ sender: UIButton) -> String?{
        let levelChoose: String? = sender.titleLabel?.text
        return levelChoose
    }
    
    @IBAction func Annuler(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
