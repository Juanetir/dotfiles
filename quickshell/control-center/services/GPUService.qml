import QtQml
import Quickshell
import Quickshell.Io

Scope {
    id: root

    property real usage: 0

    Process {
        id: gpuProcess

        command: [
            "sh",
            "-c",
            "cat /sys/class/drm/card*/device/gpu_busy_percent | head -n1"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                root.usage = Number(this.text.trim())
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true

        onTriggered: gpuProcess.running = true
    }

    Component.onCompleted: gpuProcess.running = true
}