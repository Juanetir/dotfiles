import QtQml
import Quickshell
import Quickshell.Io

Scope {
    id: root

    property real usage: 0

    Process {
        id: ramProcess

        command: ["cat", "/proc/meminfo"]

        stdout: StdioCollector {
            onStreamFinished: {
                const lines = this.text.split("\n")

                var total = 0
                var available = 0

                for (const line of lines) {
                    if (line.startsWith("MemTotal:"))
                        total = Number(line.split(/\s+/)[1])

                    if (line.startsWith("MemAvailable:"))
                        available = Number(line.split(/\s+/)[1])
                }

                if (total > 0)
                    root.usage = (1 - available / total) * 100
            }
        }
    }

    Timer {
        interval: 25000
        running: true
        repeat: true

        onTriggered: ramProcess.running = true
    }

    Component.onCompleted: ramProcess.running = true
}