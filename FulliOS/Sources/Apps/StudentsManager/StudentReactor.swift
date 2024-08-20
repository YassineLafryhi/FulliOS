//
//  Student.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 20/8/2024.
//

import ReactorKit
import RxCocoa
import RxSwift

internal struct Student {
    let id: UUID
    var name: String
}

internal class StudentReactor: Reactor, ObservableObject {
    enum Action {
        case addStudent(String)
        case updateStudent(UUID, String)
        case deleteStudent(UUID)
        case filterStudents(String)
    }

    enum Mutation {
        case addStudent(Student)
        case updateStudent(Student)
        case deleteStudent(UUID)
        case setFilteredStudents([Student])
    }

    struct State {
        var students: [Student] = []
        var filteredStudents: [Student] = []
    }

    let initialState = State()

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .addStudent(name):
            let newStudent = Student(id: UUID(), name: name)
            return Observable.just(Mutation.addStudent(newStudent))

        case let .updateStudent(id, newName):
            let updatedStudent = Student(id: id, name: newName)
            return Observable.just(Mutation.updateStudent(updatedStudent))

        case let .deleteStudent(id):
            return Observable.just(Mutation.deleteStudent(id))

        case let .filterStudents(query):
            let filtered = currentState.students.filter { $0.name.contains(query) }
            return Observable.just(Mutation.setFilteredStudents(filtered))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .addStudent(student):
            newState.students.append(student)
            newState.filteredStudents = newState.students

        case let .updateStudent(student):
            if let index = newState.students.firstIndex(where: { $0.id == student.id }) {
                newState.students[index] = student
                newState.filteredStudents = newState.students
            }

        case let .deleteStudent(id):
            newState.students.removeAll { $0.id == id }
            newState.filteredStudents = newState.students

        case let .setFilteredStudents(students):
            newState.filteredStudents = students
        }
        return newState
    }
}
