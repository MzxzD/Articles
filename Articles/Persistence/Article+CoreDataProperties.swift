//
//  Article+CoreDataProperties.swift
//  Articles
//
//  Created by Work Mode on 25.03.2023..
//
//

import Foundation
import CoreData


extension Article {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var articleDescription: String?
    @NSManaged public var author: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var image: String?

}

extension Article : Identifiable {}

extension Article: ArticlePresentible {}

