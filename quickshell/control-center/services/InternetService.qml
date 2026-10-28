import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: root

    property bool connected: false
    property bool wifiEnabled: false
    
    property string ssid: ""
    property string interfaceName: ""
    property string connectionType: ""
    property var networks: []
    property var savedNetworks: []

    property string failedNetwork: ""

    Process {
        id: networkInfo

        command: [
            "nmcli",
            "-t",
            "-f",
            "DEVICE,TYPE,STATE,CONNECTION",
            "device"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n")

                root.connected = false
                root.ssid = ""
                root.interfaceName = ""
                root.connectionType = ""

                for (const line of lines) {
                    const parts = line.split(":")

                    if (parts.length < 4)
                        continue

                    const device = parts[0]
                    const type = parts[1]
                    const state = parts[2]
                    const connection = parts.slice(3).join(":")

                    if (state === "connected") {
                        root.connected = true
                        root.interfaceName = device
                        root.connectionType = type
                        root.ssid = connection

                        break
                    }
                }

                console.log(
                    "Internet:",
                    root.connected,
                    root.ssid
                )
            }
        }
    }


    Process {
        id: wifiStatus

        command: [
            "nmcli",
            "radio",
            "wifi"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                root.wifiEnabled = text.trim() === "enabled"
            }
        }
    }

    Process {
        id: wifiToggle

        onExited: {
            wifiStatus.running = true
            networkInfo.running = true
        }
    }

    Process {
        id: networkMonitor

        command: [
            "nmcli",
            "monitor"
        ]

        stdout: SplitParser {
            onRead: {
                networkInfo.running = true
                wifiStatus.running = true
                wifiNetworks.running = true
            }
        }
    }

    Process {
        id: wifiNetworks

        command: [
            "nmcli",
            "-t",
            "-f",
            "SSID,SIGNAL,SECURITY",
            "device",
            "wifi",
            "list"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n")
                const result = []

                for (const line of lines) {
                    const parts = line.split(":")

                    if (parts.length < 3)
                        continue

                    const ssid = parts[0]
                    const signal = Number(parts[1])
                    const security = parts.slice(2).join(":")

                    if (ssid === "")
                        continue

                    result.push({
                        ssid: ssid,
                        signal: signal,
                        security: security
                    })
                }

                const seen = new Set()
                const unique = []

                for (const network of result) {
                    if (seen.has(network.ssid))
                        continue

                    seen.add(network.ssid)
                    unique.push(network)
                }

                root.networks = unique

                // console.log(
                //     "Wi-Fi networks:",
                //     JSON.stringify(unique)
                // )
            }
        }
    }
    Process {
        id: wifiConnect

        stdout: StdioCollector {
            onStreamFinished: {
                console.log("Wi-Fi output:", text)

                if (
                    text.includes("successfully activated")
                ) {
                    console.log(
                        "Connexion Wi-Fi réussie pour:",
                        root.failedNetwork
                    )

                    root.failedNetwork = ""
                }
            }
        }

        stderr: StdioCollector {
            onStreamFinished: {
                console.log("Wi-Fi error:", text)
            }
        }

        onExited: {
            networkInfo.running = true
            wifiNetworks.running = true

        }
    }

    Process {
        id: savedNetworksProcess

        command: [
            "sh",
            "-c",
            "for uuid in $(nmcli -t -f UUID connection show); do " +
            "type=$(nmcli -g connection.type connection show uuid \"$uuid\"); " +
            "if [ \"$type\" = \"802-11-wireless\" ]; then " +
            "nmcli -g 802-11-wireless.ssid connection show uuid \"$uuid\"; " +
            "fi; " +
            "done"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n")
                const result = []

                for (const line of lines) {
                    if (line === "")
                        continue

                    result.push(line)
                }

                root.savedNetworks = result

                console.log("=== Saved Network Profiles ===")
                console.log(text)
                console.log("=== End Saved Network Profiles ===")
            }
        }
    }

    function toggle() {
        if (root.connected) {
            wifiToggle.command = [
                "nmcli",
                "radio",
                "wifi",
                "off"
            ]
        } else {
            wifiToggle.command = [
                "nmcli",
                "radio",
                "wifi",
                "on"
            ]
        }

        wifiToggle.running = true
    }
    function connectWifi(ssid, pass)
    {
        root.failedNetwork = pass === "" ? ssid : ""

        if (pass === "") {
            wifiConnect.command = [
                "nmcli",
                "device",
                "wifi",
                "connect",
                ssid
            ]
        } else {
            wifiConnect.command = [
                "nmcli",
                "device",
                "wifi",
                "connect",
                ssid,
                "password",
                pass
            ]
        }

        wifiConnect.running = true
    }

    function isSavedNetwork(ssid) {
        return root.savedNetworks.includes(ssid)
    }

    Component.onCompleted: {
        networkInfo.running = true
        wifiStatus.running = true
        wifiNetworks.running = true
        networkMonitor.running = true
        savedNetworksProcess.running = true
    }
}