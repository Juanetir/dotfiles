import QtQml
import Quickshell
import Quickshell.Io

Scope {
    id: root

    property real usage: 0

    property real previousTotal: 0
    property real previousIdle: 0

    Process {
        id: cpuProcess

        command: ["cat", "/proc/stat"]

        stdout: StdioCollector {
            onStreamFinished: {
                const line = this.text.split("\n")[0]
                const values = line.trim().split(/\s+/).slice(1).map(Number)

                const idle = values[3] + values[4]
                const total = values.reduce((a, b) => a + b, 0)

                if (root.previousTotal > 0) {
                    const deltaTotal = total - root.previousTotal
                    const deltaIdle = idle - root.previousIdle

                    if (deltaTotal > 0)
                        root.usage = (1 - deltaIdle / deltaTotal) * 100
                }

                root.previousTotal = total
                root.previousIdle = idle
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true

        onTriggered: cpuProcess.running = true
    }

    Component.onCompleted: cpuProcess.running = true
}