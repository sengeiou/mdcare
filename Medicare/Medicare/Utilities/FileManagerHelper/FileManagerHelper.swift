//
//  FileManagerHelper.swift
//  Medicare
//
//  Created by sanghv on 10/26/19.
//

import Foundation
import ObjectMapper

public typealias ActionCallback = (Bool) -> Void

public final class FileManagerHelper {

    public static let shared = FileManagerHelper()

    fileprivate let fileManager = FileManager.default
    fileprivate var currentConfig: ConfigModel?

    fileprivate static let dataNameFolder    = "Data"
    fileprivate static let defaultNameFolder = "Default"
    fileprivate static let configFileName    = "Configs.config"

    private init() {

    }
}

extension FileManagerHelper {

    private func folderExists(atPath path: String) -> Bool {
        var isDir: ObjCBool = false
        guard fileManager.fileExists(atPath: path, isDirectory: &isDir) && isDir.boolValue else {
            return false
        }

        return isDir.boolValue
    }

    private func fileExists(atPath path: String) -> Bool {
        var isDir: ObjCBool = false
        guard fileManager.fileExists(atPath: path, isDirectory: &isDir) && !isDir.boolValue else {
            return false
        }

        return isDir.boolValue
    }
}

extension FileManagerHelper {

    private func getDocumentsDirectory() -> URL {
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]

        return documentsDirectory
    }

    private func getDataDirectory() -> URL {
        let folderPath = getDocumentsDirectory()
            .appendingPathComponent(FileManagerHelper.dataNameFolder, isDirectory: true)
        guard !folderExists(atPath: folderPath.path) else {
            return folderPath
        }

        _ = createNewFolder(name: FileManagerHelper.dataNameFolder, in: getDocumentsDirectory())

        return folderPath
    }

    private func getConfigFileDirectory() -> URL {
        let configFileDirectory = getDataDirectory().appendingPathComponent(FileManagerHelper.configFileName)
        guard !fileExists(atPath: configFileDirectory.path) else {
            return configFileDirectory
        }

        _ = createConfigFileInDataFolder()

        return configFileDirectory
    }
}

extension FileManagerHelper {

    func getSubFoldersFrom(parent: URL, creationDateAscending: Bool) -> [URL] {
        guard folderExists(atPath: parent.path) else {
            return []
        }

        let propertiesForKeys: [URLResourceKey] = [
            .localizedNameKey,
            .isDirectoryKey,
            .creationDateKey
        ]
        let options: FileManager.DirectoryEnumerationOptions = [
            .skipsHiddenFiles,
            .skipsSubdirectoryDescendants
        ]
        var subFolderURLs = (try? fileManager.contentsOfDirectory(at: parent,
                                                                  includingPropertiesForKeys: propertiesForKeys,
                                                                  options: options)) ?? []
        subFolderURLs = subFolderURLs.filter {
            let isDirectory = (try? $0.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) ?? false

            return isDirectory
        }

        subFolderURLs.sort(by: {
            let creationDate1 = (try? $0.resourceValues(forKeys: [.creationDateKey]).creationDate) ?? Date()
            let creationDate2 = (try? $1.resourceValues(forKeys: [.creationDateKey]).creationDate) ?? Date()

            return creationDateAscending ? creationDate1 < creationDate2 : creationDate1 > creationDate2
        })

        return subFolderURLs
    }

    func getSubFoldersInDataFolder(creationDateAscending: Bool) -> [URL] {
        return getSubFoldersFrom(parent: getDataDirectory(), creationDateAscending: creationDateAscending)
    }

    func getSubFolderNamesInDataFolder(creationDateAscending: Bool) -> [String] {
        return getItemNamesFrom(getSubFoldersInDataFolder(creationDateAscending: creationDateAscending),
                                creationDateAscending: creationDateAscending)
    }

    func getItemNamesFrom(_ urls: [URL], creationDateAscending: Bool) -> [String] {
        return urls.map {
            return ($0.lastPathComponent, (try? $0.resourceValues(forKeys: [.creationDateKey]).creationDate) ?? Date())
        }
        .sorted(by: { creationDateAscending ? $0.1 < $1.1 : $0.1 > $1.1 })
        .map { $0.0 }
    }
}

extension FileManagerHelper {

    func getFilesIn(folder: URL, creationDateAscending: Bool) -> [URL] {
        guard folderExists(atPath: folder.path) else {
            return []
        }

        let propertiesForKeys: [URLResourceKey] = [
            .localizedNameKey,
            .isDirectoryKey,
            .creationDateKey
        ]
        let options: FileManager.DirectoryEnumerationOptions = [
            .skipsHiddenFiles,
            .skipsSubdirectoryDescendants
        ]
        var fileURLs = (try? fileManager.contentsOfDirectory(at: folder,
                                                             includingPropertiesForKeys: propertiesForKeys,
                                                             options: options)) ?? []
        fileURLs = fileURLs.filter {
            let isDirectory = (try? $0.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) ?? false

            return !isDirectory
        }

        fileURLs.sort(by: {
            let creationDate1 = (try? $0.resourceValues(forKeys: [.creationDateKey]).creationDate) ?? Date()
            let creationDate2 = (try? $1.resourceValues(forKeys: [.creationDateKey]).creationDate) ?? Date()

            return creationDateAscending ? creationDate1 < creationDate2 : creationDate1 > creationDate2
        })

        return fileURLs
    }

    func getContentsOf(_ url: URL) -> Any? {
        guard let data = try? Data(contentsOf: url, options: [.alwaysMapped, .uncached]) else {
            return nil
        }

        return try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
    }

    private func getContentsOfConfigFile() -> [String: Any] {
        return (getContentsOf(getConfigFileDirectory()) as? [String: Any]) ?? [:]
    }

    func getConfig() -> ConfigModel {
        if let currentConfig = currentConfig {
            return currentConfig
        }

        let configRaw = getContentsOfConfigFile()
        let config = Mapper<ConfigModel>().map(JSON: configRaw) ?? ConfigModel()
        currentConfig = config

        /*
        let selectedFolderName = config.selectedFolder?.lastPathComponent ?? TSConstants.EMPTY_STRING
        config.selectedFolder = getDataDirectory().appendingPathComponent(selectedFolderName)
        */

        return config
    }

    func getFilesInSelectedFolder() -> [URL] {
        guard let selectedFolder = getConfig().selectedFolder else {
            return []
        }

        return getFilesIn(folder: selectedFolder, creationDateAscending: true)
    }
}

extension FileManagerHelper {

    private func createNewFile(name: String, isDirectory: Bool, in parent: URL) -> (Bool, String?) {
        let folderPath = parent.appendingPathComponent(name, isDirectory: isDirectory)
        do {
            if isDirectory {
                try fileManager.createDirectory(at: folderPath,
                                                withIntermediateDirectories: false)
            } else if fileExists(atPath: folderPath.path) {
                guard fileManager.createFile(atPath: folderPath.path, contents: nil) else {
                    return (false, "Can't create a new file.")
                }
            }

            return (true, nil)
        } catch let exp {
            return (false, exp.localizedDescription)
        }
    }

    func createNewFolder(name: String, in parent: URL) -> (Bool, String?) {
        return createNewFile(name: name, isDirectory: true, in: parent)
    }

    func createNewFolderInDataFolder(name: String) -> (Bool, String?) {
        return createNewFolder(name: name, in: getDataDirectory())
    }

    func createDefaultFolderInDataFolder() -> (Bool, String?) {
        let result = createNewFolderInDataFolder(name: FileManagerHelper.defaultNameFolder)
        let (success, _) = result
        if success {
            let config = getConfig()
            config.selectedFolder = getDataDirectory().appendingPathComponent(FileManagerHelper.defaultNameFolder)
            writeConfig(config)
        }

        return result
    }

    func createNewFile(name: String, in parent: URL) -> (Bool, String?) {
        return createNewFile(name: name, isDirectory: false, in: parent)
    }

    func createNewFileInDataFolder(name: String) -> (Bool, String?) {
        return createNewFile(name: name, in: getDataDirectory())
    }

    func createConfigFileInDataFolder() -> (Bool, String?) {
        return createNewFileInDataFolder(name: FileManagerHelper.configFileName)
    }
}

extension FileManagerHelper {

    func writeJsonData(_ json: Any, to url: URL) -> (Bool, String?) {
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
            try data.write(to: url)

            return (true, nil)
        } catch let exp {
            return (false, exp.localizedDescription)
        }
    }

    func writeConfig(_ config: ConfigModel) {
        _ = writeJsonData(config.toJSON(), to: getConfigFileDirectory())
    }
}

extension FileManagerHelper {

    func removeFile(_ url: URL) -> (Bool, String?) {
        do {
            try fileManager.removeItem(at: url)

            return (true, nil)
        } catch let exp {
            return (false, exp.localizedDescription)
        }
    }
}
