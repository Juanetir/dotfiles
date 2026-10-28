import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: root

    property bool powered: false
    property bool connected: false
    property var connectedDevice: []
    property string lastDevice: ""

    property var devices: []


    Process {
        id: bluetoothConnect

        command: [
            "bluetoothctl",
            "connect",
            root.lastDevice
        ]

        onExited: {
            bluetoothRefreshTimer.start()
        }
    }
    Process {
        id: bluetoothInfo

        command: [
            "bluetoothctl",
            "show"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                const output = text

                root.powered = output.includes("Powered: yes")

                console.log("Bluetooth powered:", root.powered)
            }
        }
    }

    Process {
        id: bluetoothDevices

        command: [
            "bluetoothctl",
            "devices"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n")
                const result = []

                for (const line of lines) {
                    const match = line.match(
                        /^Device\s+([0-9A-F:]{17})\s+(.+)$/
                    )

                    if (match) {
                        result.push({
                            mac: match[1],
                            name: match[2]
                        })
                    }
                }

                root.devices = result

                console.log(
                    "Bluetooth devices:",
                    result.length
                )
            }
        }
    }

    Process {
        id: connectedDeviceProcess

        command: [
            "bluetoothctl",
            "devices",
            "Connected"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n")
                const devices = []

                for (const line of lines) {
                    const match = line.match(
                        /^Device\s+([0-9A-F:]{17})\s+(.+)$/
                    )

                    if (match) {
                        devices.push({
                            mac: match[1],
                            name: match[2]
                        })
                    }
                }

                root.connectedDevice = devices
                root.connected = devices.length > 0

                console.log(
                    "Connected devices:",
                    JSON.stringify(devices)
                )
            }
        }
    }

    Process {
        id: bluetoothToggle

        onExited: {
            bluetoothInfo.running = true

            if (!root.powered && root.lastDevice !== "") {
                bluetoothConnect.command = [
                    "bluetoothctl",
                    "connect",
                    root.lastDevice
                ]

                bluetoothConnect.running = true
            }
        }
    }

    Timer {
        id: bluetoothRefreshTimer

        interval: 500
        repeat: false

        onTriggered: {
            connectedDeviceProcess.running = true
            bluetoothDevices.running = true
        }
    }

    function toggle() {
        if (root.powered) {
            bluetoothToggle.command = ["bluetoothctl", "power", "off"]
                    console.log(
            "Connected devices:",
            JSON.stringify(devices)
        )
        } else {
            bluetoothToggle.command = ["bluetoothctl", "power", "on"]
        }

        bluetoothToggle.running = true
    }
    function toggleDevice(mac)
    {
        const connected = root.connectedDevice.some(
            device => device.mac === mac
        )

        bluetoothConnect.command = [
            "bluetoothctl",
            connected ? "disconnect" : "connect",
            mac
        ]

        bluetoothConnect.running = true
    }

    
    Component.onCompleted: {
        bluetoothInfo.running = true
        bluetoothDevices.running = true
        connectedDeviceProcess.running = true


    }
}