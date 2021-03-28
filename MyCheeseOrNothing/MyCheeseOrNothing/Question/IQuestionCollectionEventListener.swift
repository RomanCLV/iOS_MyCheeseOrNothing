//
//  IQuestionCollectionEventListener.swift
//  MyCheeseOrNothing
//
//  Created by administrateur on 24/03/2021.
//

import Foundation;

public protocol IQuestionCollectionEventListener : class {
    
    func onFailed(e : Error);
    func onQuestionCollectionChanged(questions : [Question], mode : QuestionMode);
}
