//
//  CoreDataStack.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 23/7/2024.
//

import CoreData

internal class CoreDataStack {
    static let shared = CoreDataStack()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "EmployeeDataModel", managedObjectModel: self.managedObjectModel)

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        return container
    }()

    private lazy var managedObjectModel: NSManagedObjectModel = {
        let model = NSManagedObjectModel()

        let employeeEntity = NSEntityDescription()
        employeeEntity.name = "Employee"
        employeeEntity.managedObjectClassName = String(describing: Employee.self)

        let idAttribute = NSAttributeDescription()
        idAttribute.name = "id"
        idAttribute.attributeType = .UUIDAttributeType

        let nameAttribute = NSAttributeDescription()
        nameAttribute.name = "name"
        nameAttribute.attributeType = .stringAttributeType

        let jobAttribute = NSAttributeDescription()
        jobAttribute.name = "job"
        jobAttribute.attributeType = .stringAttributeType

        let photoAttribute = NSAttributeDescription()
        photoAttribute.name = "photo"
        photoAttribute.attributeType = .binaryDataAttributeType
        photoAttribute.isOptional = true

        employeeEntity.properties = [idAttribute, nameAttribute, jobAttribute, photoAttribute]

        model.entities = [employeeEntity]

        return model
    }()
}
