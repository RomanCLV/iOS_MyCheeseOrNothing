//
//  ResultViewController.swift
//  MyCheeseOrNothing
//
//  Created by administrateur on 25/03/2021.
//

import UIKit
import AVFoundation

class ResultViewController: UIViewController {

    @IBOutlet weak var modeLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var imageView: UIImageView!
    
    public var quiz : Quiz?;
    private var audioPlayer : AVAudioPlayer?;
    
    required init?(coder aDecoder: NSCoder) {
        self.quiz = nil;
        self.audioPlayer = nil;
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.modeLabel.text = QuestionMode.getModeFrench(mode: quiz!.getMode());
        self.resultLabel.text = "\(quiz!.getValidAnswersCount()) / \(quiz!.getQuestionsCount())";
        
        let note : Float = (Float(quiz!.getValidAnswersCount()) / Float(quiz!.getQuestionsCount())) * 100;
        self.noteLabel.text = "\(note.rounded()) %";
        
        switch quiz!.getMode() {
            case .EASY: imageView.image = UIImage(named: "logo_easy.png"); break;
            case .MEDIUM: imageView.image = UIImage(named: "logo_medium.png"); break;
            case .HARD: imageView.image = UIImage(named: "logo_hard.png"); break;
            default: break;
        }
        if note <= 33.33 {
            self.noteLabel.textColor = Theme.getInstance.colorWrong();
            self.progressBar.progressTintColor = Theme.getInstance.colorWrong();
            playSound(soundName: "song_bad", type: "mp3");
        }
        else if note <= 66.66 {
            self.noteLabel.textColor = Theme.getInstance.colorPrimaryVariant();
            self.progressBar.progressTintColor = Theme.getInstance.colorPrimaryVariant();
            playSound(soundName: "song_middle", type: "mp3");
        }
        else {
            self.noteLabel.textColor = Theme.getInstance.colorGood();
            self.progressBar.progressTintColor = Theme.getInstance.colorGood();
            playSound(soundName: "song_good", type: "mp3");
        }
        self.progressBar.setProgress(note / 100, animated: true);
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
                    self.showToast(message: error.localizedDescription, font: .systemFont(ofSize: 12.0))
                }
            }
            else {
                self.showToast(message: "Sound not found : \(soundName).\(type)", font: .systemFont(ofSize: 12.0))
            }
        }
    }
    
    @IBAction func submitBtnOnClick(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true);
    }
}
