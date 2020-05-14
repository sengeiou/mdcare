//
//  StringResource+Localized.swift
//  Medicare
//
//  Created by sanghv on 3/12/19.
//

import Foundation
import Rswift

/** StringResource_Localized Extends StringResource

*/

let lprojResourceType = "lproj"

extension StringResource {

    public func localized(_ language: String = Localize.currentLanguage()) -> String {
        guard
            let basePath = bundle.path(forResource: LanguageCode.base.rawValue, ofType: lprojResourceType),
            let baseBundle = Bundle(path: basePath)
            else {
                return self.key
        }

        let fallback = baseBundle.localizedString(forKey: key, value: key, table: tableName)

        guard
            let localizedPath = bundle.path(forResource: language, ofType: lprojResourceType),
            let localizedBundle = Bundle(path: localizedPath)
            else {
                return fallback
        }

        return localizedBundle.localizedString(forKey: key, value: fallback, table: tableName)
    }

    public func localized(_ arguments: [CVarArg], _ language: String = Localize.currentLanguage()) -> String {
        return String(format: localized(language), arguments: arguments)
    }
}
