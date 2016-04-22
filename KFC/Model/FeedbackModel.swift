//
//  FeedbackModel.swift
//  KFC
//
//  Created by Rudy Suharyadi on 4/21/16.
//  Copyright © 2016 Roodie. All rights reserved.
//

import Foundation
import CoreData

class FeedbackModel: NSObject {

    class func create(feedback:Feedback) -> Feedback{
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("Feedback", inManagedObjectContext:managedContext)
        let cdFeedback = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        feedback.guid = NSUUID().UUIDString
        
        cdFeedback.setValue(feedback.guid, forKey: "guid")
        cdFeedback.setValue(feedback.id, forKey: "id")
        cdFeedback.setValue(feedback.rating, forKey: "rating")
        
        let setQuestions = cdFeedback.mutableSetValueForKey("questions")
        for question in feedback.questions{
            
            question.guid = NSUUID().UUIDString
            question.refId = feedback.id
            question.refTable = Table.Feedback
            
            let entityName =  NSEntityDescription.entityForName("Name", inManagedObjectContext:managedContext)
            let cdQuestion = NSManagedObject(entity: entityName!, insertIntoManagedObjectContext: managedContext)
            
            cdQuestion.setValue(question.guid, forKey: "guid")
            cdQuestion.setValue(question.languageId, forKey: "languageId")
            cdQuestion.setValue(question.name, forKey: "name")
            cdQuestion.setValue(question.refId, forKey: "refId")
            cdQuestion.setValue(question.refGuid, forKey: "refGuid")
            cdQuestion.setValue(question.refTable, forKey: "refTable")
            
            setQuestions.addObject(cdQuestion)
        }
        
        let setAnswers = cdFeedback.mutableSetValueForKey("answers")
        for answer in feedback.answers{
            
            answer.guid = NSUUID().UUIDString
            answer.refId = feedback.id
            answer.refTable = Table.Feedback
            
            let entityName =  NSEntityDescription.entityForName("Name", inManagedObjectContext:managedContext)
            let cdAnswer = NSManagedObject(entity: entityName!, insertIntoManagedObjectContext: managedContext)
            
            cdAnswer.setValue(answer.guid, forKey: "guid")
            cdAnswer.setValue(answer.languageId, forKey: "languageId")
            cdAnswer.setValue(answer.name, forKey: "name")
            cdAnswer.setValue(answer.refId, forKey: "refId")
            cdAnswer.setValue(answer.refGuid, forKey: "refGuid")
            cdAnswer.setValue(answer.refTable, forKey: "refTable")
            
            setAnswers.addObject(cdAnswer)
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        return feedback
    }
    
    class func getFeedbackByRating(rating:String) -> [Feedback] {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Feedback")
        fetchRequest.predicate = NSPredicate(format: "rating = %@", rating)
        
        var feedbacks : [Feedback] = [Feedback]()
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let cdFeedbacks = results as! [NSManagedObject]
            for cdFeedback in cdFeedbacks{
                let feedback = Feedback.init(
                    guid: (cdFeedback.valueForKey("guid") as? String),
                    id: (cdFeedback.valueForKey("id") as? String),
                    rating: (cdFeedback.valueForKey("rating") as? String)
                )
                
                let cdQuestions = cdFeedback.mutableSetValueForKey("questions")
                for cdQuestion in cdQuestions{
                    let question = Name.init(
                        guid: (cdQuestion.valueForKey("guid") as? String),
                        languageId: (cdQuestion.valueForKey("languageId") as? String),
                        name: (cdQuestion.valueForKey("name") as? String),
                        refId: (cdQuestion.valueForKey("refId") as? String),
                        refGuid: (cdQuestion.valueForKey("refGuid") as? String),
                        refTable: (cdQuestion.valueForKey("refTable") as? String)
                    )
                    
                    feedback.questions.append(question)
                }
                
                let cdAnswers = cdFeedback.mutableSetValueForKey("answers")
                for cdAnswer in cdAnswers{
                    let answer = Name.init(
                        guid: (cdAnswer.valueForKey("guid") as? String),
                        languageId: (cdAnswer.valueForKey("languageId") as? String),
                        name: (cdAnswer.valueForKey("name") as? String),
                        refId: (cdAnswer.valueForKey("refId") as? String),
                        refGuid: (cdAnswer.valueForKey("refGuid") as? String),
                        refTable: (cdAnswer.valueForKey("refTable") as? String)
                    )
                    
                    feedback.answers.append(answer)
                }
                
                feedbacks.append(feedback)
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return feedbacks
    }
    
    class func deleteAllFeedback(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Feedback")
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let cdFeedbacks = results as! [NSManagedObject]
            for cdFeedback in cdFeedbacks{
                managedContext.deleteObject(cdFeedback)
            }
            try managedContext.save()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
}
