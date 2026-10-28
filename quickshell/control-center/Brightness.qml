import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls

Rectangle {
    id: root

    property var palette
    property real brightness: 0
    property real brightnessMax: 1

    width: 300
    height: 44

    color: "transparent"

    Process {
        id: getBrightness

        command: ["brightnessctl", "get"]

        stdout: StdioCollector {
            onStreamFinished: {
                const value = Number(text.trim())

                if (root.brightnessMax > 0) {
                    root.brightness = Math.max(
                        0,
                        Math.min(1, value / root.brightnessMax)
                    )
                }
            }
        }
    }

    Process {
        id: getMaxBrightness

        command: ["brightnessctl", "max"]

        stdout: StdioCollector {
            onStreamFinished: {
                const max = Number(text.trim())

                if (max > 0)
                    root.brightnessMax = max

                getBrightness.running = true
            }
        }
    }

    Process {
        id: setBrightness
    }

    Timer {
        interval: 250
        running: true
        repeat: true

        onTriggered: {
            getBrightness.running = true
        }
    }

    Slider {
        id: brightnessSlider

        anchors.left: brightnessIcon.right
        anchors.leftMargin: 12
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter

        from: 0
        to: 1
        value: root.brightness

        onMoved: {
            root.setBrightness(value)
        }

        background: Rectangle {
            x: brightnessSlider.leftPadding
            y: brightnessSlider.topPadding
                + brightnessSlider.availableHeight / 2
                - height / 2

            width: brightnessSlider.availableWidth
            height: 8
            radius: 4

            color: Qt.alpha(
                root.palette.color.border,
                0.1
            )

            Rectangle {
                width: brightnessSlider.visualPosition * parent.width
                height: parent.height / 2
                anchors.verticalCenter: parent.verticalCenter

                radius: parent.radius
                color: root.palette.color.border
            }
        }

        handle: Rectangle {
            x: brightnessSlider.leftPadding
                + brightnessSlider.visualPosition
                * (brightnessSlider.availableWidth - width)

            y: brightnessSlider.topPadding
                + brightnessSlider.availableHeight / 2
                - height / 2

            implicitWidth: 16
            implicitHeight: 16
            radius: width / 2

            color: root.palette.color.border

            Behavior on x {
                NumberAnimation {
                    duration: 100
                    easing.type: Easing.OutCubic
                }
            }
        }
    }

    Text {
        id: brightnessIcon

        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter

        property string iconText: {
            if (root.brightness < 0.25)
                return "󰃞"
            if (root.brightness < 0.50)
                return "󰃟"
            if (root.brightness < 0.75)
                return "󰃠"

            return "󰃡"
        }

        text: iconText

        onIconTextChanged: {
            morphAnimation.restart()
        }

        color: root.palette.color.border
        font.family: "Symbols Nerd Font"
        font.pixelSize: 20

        transformOrigin: Item.Center

        SequentialAnimation {
            id: morphAnimation

            ParallelAnimation {
                NumberAnimation {
                    target: brightnessIcon
                    property: "scale"
                    to: 0.7
                    duration: 80
                }

                NumberAnimation {
                    target: brightnessIcon
                    property: "opacity"
                    to: 0.7
                    duration: 80
                }

                NumberAnimation {
                    target: brightnessIcon
                    property: "rotation"
                    to: -90
                    duration: 200
                }
            }

            ParallelAnimation {
                NumberAnimation {
                    target: brightnessIcon
                    property: "scale"
                    to: 1.0
                    duration: 80
                    easing.type: Easing.OutBack
                }

                NumberAnimation {
                    target: brightnessIcon
                    property: "opacity"
                    to: 1.0
                    duration: 100
                }

                NumberAnimation {
                    target: brightnessIcon
                    property: "rotation"
                    to: 0
                    duration: 150
                    easing.type: Easing.OutBack
                }
            }
        }
    }

    function setBrightness(value) {
        const clamped = Math.max(
            0,
            Math.min(1, value)
        )

        root.brightness = clamped

        setBrightness.command = [
            "brightnessctl",
            "set",
            Math.round(clamped * 100) + "%"
        ]

        setBrightness.running = true
    }

    Component.onCompleted: {
        getMaxBrightness.running = true
    }
}