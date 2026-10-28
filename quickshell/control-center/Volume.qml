import QtQuick
import QtQuick.Controls
import Quickshell.Services.Pipewire

Rectangle {
    id: volume

    property var palette

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }
    width : 300
    color: "transparent"

    Text {
        id: volumeIcon

        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter

        property string iconText: {
            let v = slider.value
            if (v < 0.12)
                return "󰕿"
            if (v < 0.50)
                return "󰖀"
            if (v < 0.80)
                return "󰕾"

            return "󰕾"
        }
        text: iconText

        onIconTextChanged: {
            morphAnimation.restart()
        }

        color: volume.palette.color.border
        font.family: "Symbols Nerd Font"
        font.pixelSize: 24

        transformOrigin: Item.Center

        SequentialAnimation {
            id: morphAnimation

            ParallelAnimation {
                NumberAnimation {
                    target: volumeIcon
                    property: "scale"
                    to: 0
                    duration: 80
                }

                NumberAnimation {
                    target: volumeIcon
                    property: "opacity"
                    to: 0.7
                    duration: 80
                }

                NumberAnimation {
                    target: volumeIcon
                    property: "rotation"
                    to: 30
                    duration: 120
                }
            }

            ParallelAnimation {
                NumberAnimation {
                    target: volumeIcon
                    property: "scale"
                    to: 1.0
                    duration: 80
                    easing.type: Easing.OutBack
                }

                NumberAnimation {
                    target: volumeIcon
                    property: "opacity"
                    to: 1.0
                    duration: 100
                }

                NumberAnimation {
                    target: volumeIcon
                    property: "rotation"
                    to: 0
                    duration: 180
                    easing.type: Easing.OutBack
                }
            }
        }
    }

    Slider {
        id: slider

        anchors.left: volumeIcon.right
        anchors.leftMargin: 12
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter

        from: 0
        to: 1
        value: Pipewire.defaultAudioSink?.audio.volume ?? 0

        onPressedChanged: {
            if (!pressed && Pipewire.defaultAudioSink?.audio)
                Pipewire.defaultAudioSink.audio.volume = value
        }

        background: Rectangle {
            x: slider.leftPadding
            y: slider.topPadding
                + slider.availableHeight / 2
                - height / 2

            width: slider.availableWidth
            height: 8
            radius: 4

            color: Qt.alpha(
                volume.palette.color.border,
                0.1
            )

            Rectangle {
                width: slider.visualPosition * parent.width
                height: parent.height / 2
                anchors.verticalCenter: parent.verticalCenter

                radius: parent.radius
                color: volume.palette.color.border
            }
        }

        handle: Rectangle {
            x: slider.leftPadding
                + slider.visualPosition
                * (slider.availableWidth - width)

            y: slider.topPadding
                + slider.availableHeight / 2
                - height / 2

            implicitWidth: 16
            implicitHeight: 16

            radius: width / 2
            color: volume.palette.color.border

            Behavior on x {
                NumberAnimation {
                    duration: 100
                    easing.type: Easing.OutCubic
                }
            }
        }
    }
}