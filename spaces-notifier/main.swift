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
        let window = NSWindow()
        print(window)
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
            
            let pipe = Pipe()
            task.standardOutput = pipe
            task.launch()
        }
        
    }
}

let commands: [String] = [
    "osascript ~/Config/bin/update-btt-desktop-mode.scpt",
]
let workspaceObserver = WorkspaceObserver(commands: commands)
workspaceObserver.startObserving()

RunLoop.current.run()
