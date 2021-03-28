//
//  QuestionViewController.swift
//  MyCheeseOrNothing
//
//  Created by administrateur on 25/03/2021.
//

import UIKit
import AVFoundation

class QuestionViewController: UIViewController {

    public var quiz : Quiz?;
    private var userAnswer : String?;
    private var audioPlayer : AVAudioPlayer?;
    private var buttonsAnswers: [UIButton]!;
    
    @IBOutlet weak var questionLabel: UILabel!;
    @IBOutlet weak var imageView: UIImageView!;
    @IBOutlet weak var submitBtn: UIButton!;
    @IBOutlet weak var resultLabel: UILabel!;
    @IBOutlet weak var answerLabel: UILabel!;
    @IBOutlet weak var titleLabel: UILabel!;
    @IBOutlet weak var answersView: UIStackView!;
    
    required init?(coder aDecoder: NSCoder) {
        self.quiz = nil;
        self.userAnswer = nil;
        self.audioPlayer = nil;
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.buttonsAnswers = [];
        playSound(soundName: "song_quiz_start", type: "wav");
        updateInterface(question: quiz!.getNextQuestion());
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
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
                    self.showToast(message: error.localizedDescription, font: .systemFont(ofSize: 12.0));
                }
            }
            else {
                self.showToast(message: "Sound not found : \(soundName).\(type)", font: .systemFont(ofSize: 12.0));
            }
        }
    }

    @IBAction func Cancel(_ sender: Any) {
        showAlert();
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Quitter le quizz", message: "Tu ne veux pas un dernier petit bout de fromage ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Oui, quitter", style: .cancel, handler: { action in
            //self.navigationController?.popViewController(animated: true);
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "resultQuizView") as? ResultViewController
            {
                vc.quiz = self.quiz;
                //Afficher un push navigation
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }))
        alert.addAction(UIAlertAction(title: "J'en veux encore", style: .destructive))
        present(alert, animated: true)
    }

    @IBAction func submitBtnOnClick(_ sender: Any) {
        if submitBtn.isEnabled && self.userAnswer != nil {
            process();
        }
    }
    
    @IBAction func buttonAnswerOnClick(_ sender: UIButton) {
        uncheck()
        sender.checkboxAnimation {
            self.userAnswer = sender.titleLabel?.text;
            self.submitBtn.isEnabled = self.userAnswer != nil;
            //self.answerLabel.text = "Séléction : \(self.userAnswer!)";
        }
    }
    
    func uncheck(){
        buttonsAnswers.forEach { (button) in
            button.isSelected = false;
        }
    }
    
    private func process() {
        if quiz!.hasNext() {
            self.submitBtn.setTitle("Question suivante", for: .normal);
            handleProcess();
        }
        else {
            self.submitBtn.setTitle("Fin du quiz", for: .normal);
            if resultLabel.text == nil || resultLabel.text!.isEmpty {
                displayQuestionResponse();
            }
            else {
                navigateToStats();
            }
        }
    }
    
    private func handleProcess() {
        if resultLabel.text == nil || resultLabel.text!.isEmpty {
            displayQuestionResponse();
        }
        else {
            updateInterface(question: quiz!.getNextQuestion());
        }
    }
    
    private func updateInterface(question : Question) {
        self.resultLabel.text = "";
        self.answerLabel.text = "";
        self.userAnswer = nil;
        
        self.titleLabel.text = "\(QuestionMode.getModeFrench(mode: quiz!.getMode())) ~ \(quiz!.getIndexQuestion() + 1) / \(quiz!.getQuestionsCount())";
    
        self.questionLabel.text = question.question;
        
        var img = UIImage(named: question.imagePath);
        if img == nil {
            img = UIImage(named: String(question.imagePath.prefix(question.imagePath.count - 3)) + "png");
        }
        if img == nil {
            img = UIImage(named: String(question.imagePath.prefix(question.imagePath.count - 3)) + "jpg");
        }
        self.imageView.image = img;
        
        createRadioButtons(question: question);
        
        self.submitBtn.isEnabled = false;
        self.submitBtn.setTitle("Valider", for: .normal);
    }
    
    private func createRadioButtons(question : Question) {
        self.buttonsAnswers.removeAll();
        if let sublayers = self.answersView.layer.sublayers {
            for layer in sublayers {
                layer.removeFromSuperlayer()
            }
        }
            
        var index = 0;
        question.answsers.forEach { (answer) in
            
            let image1 = UIImage(named: "checkbox-unselected.png") as UIImage?;
            let image2 = UIImage(named: "checkbox-selected.png")   as UIImage?;
            
            let button = UIButton(type: .custom) as UIButton;
            button.frame = CGRect(x: 0, y: index * 50, width: 300, height: 40);
            button.titleEdgeInsets.left = 10;
            button.setTitle(answer, for: .normal);
            button.contentHorizontalAlignment = .left;
            button.setTitleColor(Theme.getInstance.colorSecondary(), for: .normal);
            button.addTarget(self, action: #selector(buttonAnswerOnClick), for: .touchUpInside);
            button.setImage(image1, for: .normal);
            button.setImage(image2, for: .selected);
            
            self.buttonsAnswers.append(button);
            self.answersView.addSubview(button);
            index += 1;
        }
    }
    
    private func displayQuestionResponse() {
        if (quiz!.checkAnswer(answer: self.userAnswer!)) {
            self.resultLabel.text = "Bonne réponse !";
            self.answerLabel.text = "";
            self.resultLabel.textColor = Theme.getInstance.colorGood();
            playSound(soundName: "song_right_answer", type: "wav");
        }
        else {
            self.resultLabel.text = "Mauvaise réponse !";
            self.answerLabel.text = "La bonne réponse est \(quiz!.getCurrentQuestion().answer).";
            self.resultLabel.textColor = Theme.getInstance.colorWrong();
            playSound(soundName: "song_wring_answer", type: "wav");
        }
    }
    
    private func navigateToStats() {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "resultQuizView") as? ResultViewController
        {
            vc.quiz = self.quiz;
            //Afficher un push navigation
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
