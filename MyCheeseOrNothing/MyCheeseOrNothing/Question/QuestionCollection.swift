//
//  QuestionCollection.swift
//  MyCheeseOrNothing
//
//  Created by administrateur on 24/03/2021.
//

import Foundation;
import UIKit;

public class QuestionCollection {
    
    private var listeners : [IQuestionCollectionEventListener];
    
    public init() {
        self.listeners = [];
    }
    
    public func addListener(listener : IQuestionCollectionEventListener) {
        for i in 0 ..< self.listeners.count {
            if self.listeners[i] === listener {
                return;
            }
        }
        self.listeners.append(listener);
    }
    
    public func removeListener(listener : IQuestionCollectionEventListener) {
        for i in 0..<self.listeners.count {
            if self.listeners[i] === listener {
                self.listeners.remove(at: i);
                break;
            }
        }
    }
    
    func onFailed(e : Error) {
        DispatchQueue.main.async {
            for i in 0..<self.listeners.count {
                self.listeners[i].onFailed(e: e);
            }
        }
    }
    
    func onQuestionCollectionChanged(questionCollection : [Question], mode : QuestionMode) {
        DispatchQueue.main.async {
            for i in 0..<self.listeners.count {
                self.listeners[i].onQuestionCollectionChanged(questions: questionCollection, mode: mode);
            }
        }
    }
    
    public func fetchQuestions(mode : QuestionMode) {
        
        var urlStr = "http://gryt.tech:8080/mycheeseornothing/";
        if (mode != .ALL && mode != .RANDOM) {
            urlStr += "?difficulty=\(mode.rawValue)";
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let url = URL(string: urlStr)!
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                self.onFailed(e: error!)
            }
            else {
                if let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) {
                    if let data = json as? [[String: AnyObject]] {
                        var questionCollection : [Question] = []
                        
                        for i in 0..<data.count {
                            let questionData = data[i] as [String: AnyObject];
                            let answersData  = (questionData["responses"] as? [AnyObject])!;
                            var answers : [String] = [];
                            for j in 0..<answersData.count {
                                answers.append((answersData[j] as? String)!);
                            }
                            let question  = (questionData["question"]  as? String)!;
                            let answer    = (questionData["answer"]    as? String)!;
                            let mode      = (QuestionMode(rawValue: (questionData["mode"] as? String)!))!;
                            let imageName = (questionData["imageName"] as? String)!;
                            
                            questionCollection.append(Question(
                                                        question: question,
                                                        answsers: answers,
                                                        answer: answer,
                                                        imagePath: imageName,
                                                        mode: mode));
                        }
                        self.onQuestionCollectionChanged(questionCollection: questionCollection, mode: mode);
                    }
                }
                else {
                    //var err = Error("Failed to load a MyCustomCell from the table.");
                    //self.onFailed(e: err);
                }
            }
        }
        task.resume();
    }
}
