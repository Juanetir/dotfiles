import QtQuick
import Quickshell.Io

Rectangle {
    
    id: caffeine

    property var palette
    property bool active: false

    width: 42
    height: 42
    radius: width / 2

    color: {
        const alpha = (!active ? 0.4 : 0.3)
        const color = (!active ? caffeine.palette.color.font : caffeine.palette.color.border)
        
        return Qt.alpha(
            color,
            alpha
        )
    }
    border.color : !active ?  "transparent" : caffeine.palette.color.buttons
    
    Process {
        id: checkHypridle

        command: ["pgrep", "-x", "hypridle"]

        stdout: StdioCollector {
            onStreamFinished: {
                caffeine.active = text.trim().length === 0

                console.log("ACTIVE:", caffeine.active)
            }
        }
    }
    Behavior on color {
        ColorAnimation {
            duration: 180
        }
    }

    Text {
        anchors.centerIn: parent

        text: ""

        color: !caffeine.active
            ? caffeine.palette.color.background
            : caffeine.palette.color.border

        font.family: "Symbols Nerd Font"
        font.pixelSize: active? 24 : 28

        Behavior on color {
            ColorAnimation {
                duration: 280
            }
        }
    }
    function setCaffeine(enabled) {
        if (enabled) {
            caffeineProcess.command = ["sh", "-c", "pkill -x hypridle"]
        } else {
            caffeineProcess.command = [
                "sh", "-c",
                "pkill -x hypridle; hypridle >/dev/null 2>&1 &"
            ]
        }

        caffeineProcess.running = true
    }
    
    MouseArea {
        anchors.fill: parent

        onClicked: {
            caffeine.active = !caffeine.active
            caffeine.setCaffeine(caffeine.active)
        }
    }                               
    
    Process {
        id: caffeineProcess
    }

    Component.onCompleted: {
        checkHypridle.running = true
    }
}