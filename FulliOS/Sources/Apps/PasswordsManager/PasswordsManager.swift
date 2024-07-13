//
//  PasswordManager.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 8/6/2024.
//

import CryptoKit
import Foundation
import LocalAuthentication
import RealmSwift
import SwiftUI

internal struct Account: Identifiable, Codable {
    var id: Int
    var name: String
    var password: String
}

internal class RealmManager: ObservableObject {
    static let shared = RealmManager()
    private var realm: Realm

    private init() {
        realm = try! Realm()
    }

    private let key = SymmetricKey(size: .bits256)

    func fetchAccounts(completion: @escaping ([Account]) -> Void) {
        let accounts = realm.objects(AccountObject.self).map { accountObject -> Account in
            let decryptedPassword = self.decryptPassword(accountObject.password) ?? ""
            return Account(id: accountObject.id, name: accountObject.name, password: decryptedPassword)
        }
        completion(Array(accounts))
    }

    func saveAccount(_ account: Account, completion: @escaping (Result<Void, Error>) -> Void) {
        let accountObject = AccountObject()
        accountObject.id = account.id
        accountObject.name = account.name
        if let encryptedPassword = encryptPassword(account.password) {
            accountObject.password = encryptedPassword
        } else {
            completion(.failure(NSError(domain: "EncryptionError", code: 1, userInfo: nil)))
            return
        }

        do {
            try realm.write {
                realm.add(accountObject)
            }
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }

    private func encryptPassword(_ password: String) -> Data? {
        guard let data = password.data(using: .utf8) else {
            return nil
        }
        do {
            let sealedBox = try AES.GCM.seal(data, using: key)
            return sealedBox.combined
        } catch {
            print("Encryption error: \(error)")
            return nil
        }
    }

    private func decryptPassword(_ data: Data) -> String? {
        do {
            let sealedBox = try AES.GCM.SealedBox(combined: data)
            let decryptedData = try AES.GCM.open(sealedBox, using: key)
            return String(data: decryptedData, encoding: .utf8)
        } catch {
            print("Decryption error: \(error)")
            return nil
        }
    }
}

internal class AccountObject: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
    @Persisted var password: Data
}

internal struct PasswordsManager: View {
    @State private var accounts: [Account] = []
    @State private var showingAlert = false
    @State private var showingSaveAlert = false
    @State private var newAccountName = ""
    @State private var newAccountPassword = ""

    var body: some View {
        VStack {
            List(accounts, id: \.id) { account in
                HStack {
                    Text(account.name)
                    Spacer()
                    Button("Copy to Clipboard") {
                        authenticateUser { success in
                            if success {
                                UIPasteboard.general.string = account.password
                            } else {
                                showingAlert = true
                            }
                        }
                    }
                }
            }
            .alert("Authentication Failed", isPresented: $showingAlert) {
                Button("OK", role: .cancel) {}
            }
            .onAppear {
                RealmManager.shared.fetchAccounts { fetchedAccounts in
                    accounts = fetchedAccounts
                }
            }

            FButton("Add New Account") {
                showingSaveAlert = true
            }
            .alert("New Account", isPresented: $showingSaveAlert) {
                VStack {
                    TextField("Account Name", text: $newAccountName)
                    SecureField("Password", text: $newAccountPassword)
                    Button("Save") {
                        let newAccount = Account(id: accounts.count + 1, name: newAccountName, password: newAccountPassword)
                        RealmManager.shared.saveAccount(newAccount) { result in
                            switch result {
                            case .success:
                                accounts.append(newAccount)
                                newAccountName = ""
                                newAccountPassword = ""
                                showingSaveAlert = false
                            case let .failure(error):
                                print("Error saving account: \(error)")
                            }
                        }
                    }
                }
            } message: {
                Text("Enter the account details.")
            }
        }
    }

    func authenticateUser(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate to reveal the password."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, _ in
                DispatchQueue.main.async {
                    completion(success)
                }
            }
        } else {
            print("Biometric authentication not available.")
            completion(false)
        }
    }
}
