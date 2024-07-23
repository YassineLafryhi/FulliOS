//
//  ManageEmployeesView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 23/7/2024.
//

import CoreData
import SwiftUI
import UIKit

@objc(Employee)
public class Employee: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var job: String
    @NSManaged public var photo: Data?
}

extension Employee {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<Employee> {
        NSFetchRequest<Employee>(entityName: "Employee")
    }

    @nonobjc
    class func entity(in context: NSManagedObjectContext) -> NSEntityDescription {
        NSEntityDescription.entity(forEntityName: "Employee", in: context)!
    }
}

struct ManageEmployeesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Employee.name, ascending: true)],
        animation: .default)
    private var employees: FetchedResults<Employee>

    @State private var showingAddEmployee = false

    var body: some View {
        NavigationView {
            List {
                ForEach(employees, id: \.id) { employee in
                    NavigationLink(destination: EmployeeDetailView(employee: employee)) {
                        EmployeeRowView(employee: employee)
                    }
                }
                .onDelete(perform: deleteEmployees)
            }
            .navigationTitle("Employees")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddEmployee = true }) {
                        Label("Add Employee", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddEmployee) {
                AddEmployeeView()
            }
        }
    }

    private func deleteEmployees(offsets: IndexSet) {
        withAnimation {
            offsets.map { employees[$0] }.forEach(viewContext.delete)
            saveContext()
        }
    }

    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct EmployeeRowView: View {
    let employee: Employee

    var body: some View {
        HStack {
            if let photoData = employee.photo, let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)
            }

            VStack(alignment: .leading) {
                Text(employee.name)
                    .font(.headline)
                Text(employee.job)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct AddEmployeeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode

    @State private var name = ""
    @State private var job = ""
    @State private var image: UIImage?
    @State private var showingImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Employee Information")) {
                    TextField("Name", text: $name)
                    TextField("Job", text: $job)
                }

                Section(header: Text("Photo")) {
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    }

                    Button("Take Photo") {
                        sourceType = .camera
                        showingImagePicker = true
                    }
                }
            }
            .navigationTitle("Add Employee")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveEmployee()
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                EmployeeImagePicker(image: $image, sourceType: sourceType)
            }
        }
    }

    private func saveEmployee() {
        let newEmployee = Employee(context: viewContext)
        newEmployee.id = UUID()
        newEmployee.name = name
        newEmployee.job = job
        newEmployee.photo = image?.jpegData(compressionQuality: 0.8)

        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct EmployeeDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode

    @State private var employee: Employee
    @State private var name: String
    @State private var job: String
    @State private var image: UIImage?
    @State private var showingImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera

    init(employee: Employee) {
        _employee = State(initialValue: employee)
        _name = State(initialValue: employee.name)
        _job = State(initialValue: employee.job)
        if let photoData = employee.photo {
            _image = State(initialValue: UIImage(data: photoData))
        }
    }

    var body: some View {
        Form {
            Section(header: Text("Employee Information")) {
                TextField("Name", text: $name)
                TextField("Job", text: $job)
            }

            Section(header: Text("Photo")) {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                }

                Button("Take New Photo") {
                    sourceType = .camera
                    showingImagePicker = true
                }
            }

            Section {
                Button("Save Changes") {
                    saveChanges()
                }
            }

            Section {
                Button("Delete Employee") {
                    deleteEmployee()
                }
                .foregroundColor(.red)
            }
        }
        .navigationTitle("Edit Employee")
        .sheet(isPresented: $showingImagePicker) {
            EmployeeImagePicker(image: $image, sourceType: sourceType)
        }
    }

    private func saveChanges() {
        employee.name = name
        employee.job = job
        employee.photo = image?.jpegData(compressionQuality: 0.8)

        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    private func deleteEmployee() {
        viewContext.delete(employee)
        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct EmployeeImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    let sourceType: UIImagePickerController.SourceType

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_: UIImagePickerController, context _: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: EmployeeImagePicker

        init(_ parent: EmployeeImagePicker) {
            self.parent = parent
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            picker.dismiss(animated: true)
        }
    }
}
