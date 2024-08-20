//
//  StudentListView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 20/8/2024.
//

import ReactorKit
import RxSwift
import SwiftUI

internal struct StudentsManagerView: SwiftUI.View {
    @ObservedObject var reactor: StudentReactor = .init()
    @State private var newStudentName = ""
    @State private var filterQuery = ""

    var body: some SwiftUI.View {
        VStack {
            HStack {
                TextField("Enter student name", text: $newStudentName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Add Student") {
                    reactor.action.onNext(.addStudent(newStudentName))
                    newStudentName = ""
                }
            }
            .padding()

            TextField("Filter", text: $filterQuery)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: filterQuery) { query in
                    reactor.action.onNext(.filterStudents(query))
                }

            List {
                ForEach(reactor.currentState.filteredStudents, id: \.id) { student in
                    HStack {
                        Text(student.name)
                        Spacer()
                        Button("Delete") {
                            reactor.action.onNext(.deleteStudent(student.id))
                        }
                    }
                }
            }
        }
        .padding()
    }
}
