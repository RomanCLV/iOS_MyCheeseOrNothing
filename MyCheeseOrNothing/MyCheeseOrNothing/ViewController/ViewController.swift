//
//  ViewController.swift
//  MyCheeseOrNothing
//
//  Created by Emerick CHALET on 24/03/2021.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, IQuestionCollectionEventListener {

    private var questionCollection : QuestionCollection;
    private var isQuiz : Bool;
    private var audioPlayer : AVAudioPlayer?;
    
    @IBOutlet weak var soundsEffectToggle: UISwitch!;
    
    required init?(coder aDecoder: NSCoder) {
        let app = UIApplication.shared.delegate as! AppDelegate;
        self.questionCollection = app.questionCollection;
        self.isQuiz = true;
        super.init(coder: aDecoder);
        playSound(soundName: "song_wellcome", type: "mp3");
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        let app = UIApplication.shared.delegate as! AppDelegate;
        self.soundsEffectToggle.setOn(app.hasSoundsEffect, animated: true);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        questionCollection.addListener(listener: self);
        navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated);
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        questionCollection.removeListener(listener: self);
        super.viewWillDisappear(animated);
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.audioPlayer?.stop();
        super.viewDidDisappear(animated);
    }
        
    private func playSound(soundName : String, type : String) {
        if self.audioPlayer != nil {
            self.audioPlayer!.stop();
            self.audioPlayer = nil;
        }
        let app = UIApplication.shared.delegate as! AppDelegate;
        if app.hasSoundsEffect {
            let sound = Bundle.main.path(forResource: soundName, ofType: type);
            if sound != nil {
                do {
                    self.audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
                    self.audioPlayer?.play();
                }
                catch {
                    onFailed(e: error);
                }
            }
            else {
                print("Sound not found : \(soundName).\(type)");
            }
        }
    }
    
    @IBAction func soundsEffectToggleOnClick(_ sender: Any) {
        let app = UIApplication.shared.delegate as! AppDelegate;
        app.hasSoundsEffect = self.soundsEffectToggle.isOn;
    }
    
    @IBAction func learnCheeseOnClick(_ sender: Any) {
        self.isQuiz = true;
    }
    
    @IBAction func allQuestionsOnClick(_ sender: Any) {
        self.isQuiz = false;
        self.questionCollection.fetchQuestions(mode: .ALL);
    }
    
    func onFailed(e : Error) {
        self.showToast(message: e.localizedDescription, font: .systemFont(ofSize: 12.0))
    }
    
    func onQuestionCollectionChanged(questions: [Question], mode: QuestionMode) {
        // navigate on the view
        if self.isQuiz {
            let quiz = Quiz(questions: questions, mode: mode);
            quiz.mixQuestions();
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "questionView") as? QuestionViewController
            {
                //Afficher un push navigation
                vc.quiz = quiz;
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else {
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "listQuestionView") as? ListQuestionsTableViewController
            {
                vc.questions = questions;
                //Afficher un push navigation
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
