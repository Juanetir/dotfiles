import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: root

    property string profile: "balanced"

    Process {
        id: profileInfo

        command: [
            "powerprofilesctl",
            "get"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                root.profile = text.trim()

                console.log(
                    "Power profile:",
                    root.profile
                )
            }
        }
    }


    Process {
        id: profileSet

        onExited: {
            profileInfo.running = true
        }
    }

    function setProfile(profileName)
    {
        profileSet.command = [
            "powerprofilesctl",
            "set",
            profileName
        ]

        profileSet.running = true
    }

    Component.onCompleted: {
        profileInfo.running = true
    }
}