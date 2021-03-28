//
//  Question.swift
//  MyCheeseOrNothing
//
//  Created by administrateur on 24/03/2021.
//

import Foundation;

public class Question {
    
    public let question : String;
    public let answsers : [String];
    public let answer : String;
    public let imagePath : String;
    public let mode : QuestionMode;

    public init(question: String, answsers: [String], answer: String, imagePath: String, mode: QuestionMode) {
        self.question = question;
        self.answsers = answsers;
        self.answer = answer;
        self.imagePath = imagePath;
        self.mode = mode;
    }
    
    public func isValid(answer: String) -> Bool {
        return self.answer == answer;
    }
}
