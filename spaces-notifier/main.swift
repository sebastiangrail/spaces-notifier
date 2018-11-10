import Foundation
import AppKit

struct Configuration: Decodable {
    var commands: [String]
}

class WorkspaceObserver: NSObject {
    
    let commands: [String]
    
    init(commands: [String]) {
        self.commands = commands
    }
    
    func startObserving() {
        // We won't receive activeSpaceDidChangeNotification unless we create window
        let _ = NSWindow()
        NSWorkspace.shared.notificationCenter.addObserver(
            self,
            selector: #selector(spaceChanged),
            name: NSWorkspace.activeSpaceDidChangeNotification,
            object: nil)
    }
    
    @objc func spaceChanged() {
        commands.forEach { command in
            let task = Process()
            task.launchPath = "/bin/sh"
            task.arguments = ["-c", command]
            task.launch()
        }
        
    }
}

extension FileHandle {
    func write(_ string: String) {
        write((string + "\n").data(using: .utf8) ?? Data())
    }
}

let configURL = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(".spaces-notifier.json")
let workspaceObserver: WorkspaceObserver
do {
    let jsonData = try Data(contentsOf: configURL)
    let configuration = try JSONDecoder().decode(Configuration.self, from: jsonData)
    workspaceObserver = WorkspaceObserver(commands: configuration.commands)
    workspaceObserver.startObserving()
} catch let error {
    FileHandle.standardError.write(error.localizedDescription)
    exit(1)
}

RunLoop.current.run()
