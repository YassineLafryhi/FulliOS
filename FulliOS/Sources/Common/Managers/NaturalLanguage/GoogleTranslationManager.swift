//
//  GoogleTranslationManager.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 8/6/2024.
//

import Foundation
import MLKit

internal class GoogleTranslationManager {
    private var translator: Translator?
    public func detectLanguage(text: String, completion: @escaping (String?, Error?) -> Void) {
        let languageId = LanguageIdentification.languageIdentification()

        languageId.identifyLanguage(for: text) { languageCode, error in
            if let error = error {
                completion(nil, error)
            } else if let languageCode = languageCode, languageCode != "und" {
                completion(languageCode, nil)
            } else {
                completion(nil, nil)
            }
        }
    }

    public func translate(text: String, to targetLanguageCode: String, completion: @escaping (String?, Error?) -> Void) {
        detectLanguage(text: text) { languageCode, error in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let identifiedLanguageCode = languageCode, identifiedLanguageCode != "und" else {
                completion(nil, nil)
                return
            }

            let options = TranslatorOptions(
                sourceLanguage: TranslateLanguage(rawValue: identifiedLanguageCode),
                targetLanguage: TranslateLanguage(rawValue: targetLanguageCode))
            self.translator = Translator.translator(options: options)

            self.translator?.downloadModelIfNeeded { error in
                guard error == nil else {
                    completion(nil, error)
                    return
                }

                self.translator?.translate(text) { translatedText, error in
                    completion(translatedText, error)
                }
            }
        }
    }
}
