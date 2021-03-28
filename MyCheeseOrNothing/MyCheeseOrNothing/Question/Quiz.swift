//
//  Quiz.swift
//  MyCheeseOrNothing
//
//  Created by administrateur on 24/03/2021.
//

import Foundation;

public class Quiz {
    
    private let mode : QuestionMode;
    private var mixedIndex : [Int];
    private var indexQuestion : Int;
    private var currentQuestion : Question?;
    private var validAnswersCount : Int;
    private let questions : [Question];
    
    public init(questions : [Question], mode: QuestionMode) {
        self.questions = questions;
        self.mode = mode;
        self.mixedIndex = [];
        self.validAnswersCount = 0;
        self.indexQuestion = 0;
        self.currentQuestion = nil;
    }
    
    private func getNumberOfQuestions() -> Int {
        switch self.mode
        {
            case .ALL: return self.questions.count;
            case .RANDOM: return Int.random(in: 5...11);
            case .EASY: return 5;
            case .MEDIUM: return 8;
            case .HARD: return 11;
        }
    }
    
    public func mixQuestions() {
        self.currentQuestion = nil;
        self.mixedIndex = [];
        let size = min(getNumberOfQuestions(), self.questions.count);
        
        var allIndex : [Int] = [];
        for i in 0..<self.questions.count {
            allIndex.append(i);
        }
        
        var indexToRemove : Int;
        for _ in 0..<size {
            indexToRemove = Int.random(in: 0..<allIndex.count);
            self.mixedIndex.append(allIndex[indexToRemove]);
            allIndex.remove(at: indexToRemove);
        }
    }
    
    public func mixAnswers(answers: [String]) -> [String] {
        var allIndex : [Int] = [];
        for i in 0..<answers.count {
            allIndex.append(i);
        }
        
        var newAnswers : [String] = [];
        var indexToRemove : Int;
        for _ in 0..<answers.count {
            indexToRemove = Int.random(in: 0..<allIndex.count);
            newAnswers.append(answers[indexToRemove]);
            allIndex.remove(at: indexToRemove);
        }
        return newAnswers;
    }
    
    public func get(index: Int) -> Question {
        return self.questions[index];
    }
    
    public func getValidAnswersCount() -> Int {
        return self.validAnswersCount;
    }
    
    public func getIndexQuestion() -> Int {
        return self.indexQuestion;
    }
    
    public func getQuestionsCount() -> Int {
        return self.mixedIndex.count;
    }
    
    public func getMode() -> QuestionMode {
        return self.mode;
    }
    
    public func hasNext() -> Bool {
        return self.indexQuestion + 1 < self.mixedIndex.count;
    }
    
    public func getCurrentQuestion() -> Question {
        return self.currentQuestion!;
    }
    
    public func getNextQuestion() -> Question {
        self.indexQuestion = self.currentQuestion == nil ? 0 : self.indexQuestion + 1;
        self.currentQuestion = get(index: self.mixedIndex[self.indexQuestion]);
        return self.currentQuestion!;
    }
    
    public func checkAnswer(answer : String) -> Bool {
        if self.currentQuestion!.isValid(answer: answer) {
            self.validAnswersCount += 1;
            return true;
        }
        return false;
    }
}
