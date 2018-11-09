import Foundation
import AppKit

struct Configuration: Codable {
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
            selector: #selector(spaceChanged(_:)),
            name: NSWorkspace.activeSpaceDidChangeNotification,
            object: nil)
    }
    
    @objc func spaceChanged(_ x: Any) {
        commands.forEach { command in
            let task = Process()
            task.launchPath = "/bin/sh"
            task.arguments = ["-c", command]
            task.launch()
        }
        
    }
}

let commands: [String] = [
    
]
let workspaceObserver = WorkspaceObserver(commands: commands)
workspaceObserver.startObserving()

RunLoop.current.run()
