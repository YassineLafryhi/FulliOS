//
//  FileManagerView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 23/7/2024.
//

import SwiftUI

internal struct IdentifiableURL: Identifiable {
    let id = UUID()
    let url: URL
}

internal struct FileManagerView: View {
    @State private var currentPath: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    @State private var contents: [URL] = []
    @State private var selectedItems: Set<URL> = []
    @State private var isCreatingNew = false
    @State private var newItemName = ""
    @State private var isFolder = false
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var renamingItem: IdentifiableURL?
    @State private var newName = ""
    @State private var copiedItems: [URL] = []

    private let fileManager = FileManager.default

    var body: some View {
        NavigationView {
            List {
                if currentPath != fileManager.urls(for: .documentDirectory, in: .userDomainMask).first! {
                    Button(action: navigateUp) {
                        HStack {
                            Image(systemName: "arrow.up.doc")
                            Text("..")
                        }
                    }
                }

                ForEach(contents, id: \.self) { item in
                    FileRowView(url: item, isSelected: selectedItems.contains(item))
                        .onTapGesture { selectItem(item) }
                        .contextMenu {
                            Button("Rename") { startRenaming(item) }
                            Button("Delete") { deleteItem(item) }
                            Button("Duplicate") { duplicateItem(item) }
                            if !isFolder(item) {
                                Button("Copy") { copyItems([item]) }
                            }
                        }
                }
            }
            .navigationTitle("Files")
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button(action: { isCreatingNew = true }) {
                        Image(systemName: "plus")
                    }
                    Spacer()
                    Button("Select All") { selectAllItems() }
                    Spacer()
                    Button("Copy") { copyItems(Array(selectedItems)) }
                        .disabled(selectedItems.isEmpty)
                    Spacer()
                    Button("Paste") { pasteItems() }
                        .disabled(copiedItems.isEmpty)
                    Spacer()
                    Button("Delete") { deleteSelectedItems() }
                        .disabled(selectedItems.isEmpty)
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .sheet(isPresented: $isCreatingNew) {
                CreateNewItemView(
                    isPresented: $isCreatingNew,
                    isFolder: $isFolder,
                    itemName: $newItemName,
                    onCreate: createNewItem)
            }
            .sheet(item: $renamingItem) { item in
                RenameItemView(item: item, newName: $newName, onRename: renameItem)
            }
        }
        .onAppear(perform: loadContents)
    }

    private func loadContents() {
        do {
            contents = try fileManager.contentsOfDirectory(at: currentPath, includingPropertiesForKeys: nil)
        } catch {
            showError("Failed to load contents", error.localizedDescription)
        }
    }

    private func navigateUp() {
        currentPath = currentPath.deletingLastPathComponent()
        loadContents()
    }

    private func selectItem(_ item: URL) {
        if isFolder(item) {
            currentPath = item
            loadContents()
        } else {
            if selectedItems.contains(item) {
                selectedItems.remove(item)
            } else {
                selectedItems.insert(item)
            }
        }
    }

    private func isFolder(_ url: URL) -> Bool {
        var isDirectory: ObjCBool = false
        fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory)
        return isDirectory.boolValue
    }

    private func createNewItem() {
        let newItemURL = currentPath.appendingPathComponent(newItemName)
        do {
            if isFolder {
                try fileManager.createDirectory(at: newItemURL, withIntermediateDirectories: false)
            } else {
                fileManager.createFile(atPath: newItemURL.path, contents: nil)
            }
            loadContents()
        } catch {
            showError("Failed to create item", error.localizedDescription)
        }
    }

    private func startRenaming(_ item: URL) {
        renamingItem = IdentifiableURL(url: item)
        newName = item.lastPathComponent
    }

    private func renameItem() {
        guard let item = renamingItem?.url else { return }
        let newURL = item.deletingLastPathComponent().appendingPathComponent(newName)
        do {
            try fileManager.moveItem(at: item, to: newURL)
            loadContents()
        } catch {
            showError("Failed to rename item", error.localizedDescription)
        }
        renamingItem = nil
    }

    private func deleteItem(_ item: URL) {
        do {
            try fileManager.removeItem(at: item)
            loadContents()
        } catch {
            showError("Failed to delete item", error.localizedDescription)
        }
    }

    private func duplicateItem(_ item: URL) {
        let newName = item.deletingPathExtension()
            .lastPathComponent + " copy" + (item.pathExtension.isEmpty ? "" : "." + item.pathExtension)
        let newURL = item.deletingLastPathComponent().appendingPathComponent(newName)
        do {
            try fileManager.copyItem(at: item, to: newURL)
            loadContents()
        } catch {
            showError("Failed to duplicate item", error.localizedDescription)
        }
    }

    private func copyItems(_ items: [URL]) {
        copiedItems = items
    }

    private func pasteItems() {
        for item in copiedItems {
            let newURL = currentPath.appendingPathComponent(item.lastPathComponent)
            do {
                try fileManager.copyItem(at: item, to: newURL)
            } catch {
                showError("Failed to paste item", error.localizedDescription)
            }
        }
        loadContents()
    }

    private func selectAllItems() {
        selectedItems = Set(contents)
    }

    private func deleteSelectedItems() {
        for item in selectedItems {
            deleteItem(item)
        }
        selectedItems.removeAll()
    }

    private func showError(_ title: String, _ message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}

internal struct FileRowView: View {
    let url: URL
    let isSelected: Bool

    var body: some View {
        HStack {
            Image(systemName: isDirectory ? "folder" : "doc")
            Text(url.lastPathComponent)
            Spacer()
            if isSelected {
                Image(systemName: "checkmark")
            }
        }
    }

    private var isDirectory: Bool {
        var isDirectory: ObjCBool = false
        FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory)
        return isDirectory.boolValue
    }
}

internal struct CreateNewItemView: View {
    @Binding var isPresented: Bool
    @Binding var isFolder: Bool
    @Binding var itemName: String
    let onCreate: () -> Void

    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $itemName)
                Toggle("Is Folder", isOn: $isFolder)
            }
            .navigationTitle("Create New Item")
            .navigationBarItems(
                leading: Button("Cancel") { isPresented = false },
                trailing: Button("Create") {
                    onCreate()
                    isPresented = false
                })
        }
    }
}

internal struct RenameItemView: View {
    let item: IdentifiableURL
    @Binding var newName: String
    let onRename: () -> Void
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                TextField("New Name", text: $newName)
            }
            .navigationTitle("Rename Item")
            .navigationBarItems(
                leading: Button("Cancel") { presentationMode.wrappedValue.dismiss() },
                trailing: Button("Rename") {
                    onRename()
                    presentationMode.wrappedValue.dismiss()
                })
        }
    }
}
