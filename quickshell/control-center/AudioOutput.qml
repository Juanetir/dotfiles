import QtQuick
import QtQuick.Controls
import "./services"

Item {
    id: audioOutput

    property var palette
    implicitWidth: 300
    implicitHeight: 30

    AudioOutputService {
        id : audioOutputService
    }

    Text {
        id: outputButton

        text: audioOutputService.currentOutput ? (
          audioOutputService.currentOutput.nickname
          || audioOutputService.currentOutput.description
          || audioOutputService.currentOutput.name
        ) : "No audio output"
        
        color: Qt.alpha(audioOutput.palette.color.font, 0.45)
        MouseArea {
            anchors.fill: parent        
            onClicked: {
                outputMenu.open()
                audioOutputService.refresh()
                console.log("=== TEST ===")
                console.log("models:", audioOutputService.current.description)
            }
        }
    }

    Popup {
        id: outputMenu
        y : -40
        x : -30
        property bool opening: false

        signal openingFinished()

        onOpened: {
            
            opening = true
            
            popupAnimation.start()
        }
        onClosed: {
            for (var i = 0; i < outputList.count; i++) {
                var item = outputList.itemAtIndex(i)

                if (item) {
                    item.opacity = 0.1
                    item.scale = 0.2
                }
            }
        }

        width: 300
        height: Math.min(
            audioOutputService.outputs.length * 40 + 20,
            150
        )

        opacity: 1
        transformOrigin: Item.Top

        background: Rectangle {
            id: popupBackground

            color: Qt.alpha(
                audioOutput.palette.color.background,
                1
            )

            radius: 10
            scale: 0.02

            NumberAnimation {
                id: popupAnimation

                target: popupBackground
                property: "scale"

                from: 0.02
                to: 1

                duration: 300
                easing.type: Easing.OutCubic

                onFinished: {
                    outputMenu.opening = false
                    outputMenu.openingFinished()
                }
            }
        }

        contentItem: Item {
            clip: true

            ListView {
                id: outputList

                anchors.fill: parent
                anchors.margins: 10

                spacing: 4
                boundsBehavior: Flickable.StopAtBounds

                model: audioOutputService.outputs

                delegate: Rectangle {
                    id: delegate

                    width: outputList.width
                    height: 36

                    radius: 10

                    opacity: 0.1
                    scale: 0.3

                    color: {
                        const alpha = (hoverHandler.hovered ? 0.30 : 0.20)

                        return Qt.alpha(
                            audioOutput.palette.color.font,
                            alpha
                        )
                    }
                    Behavior on color {
                        ColorAnimation {
                            duration: 200
                        }
                    }
                    HoverHandler {
                        id: hoverHandler
                    }

                    Connections {
                        target: outputMenu

                        function onOpeningFinished() {
                            
                            appearAnimation.start()
                        }
                    }

                    SequentialAnimation {
                        id: appearAnimation

                        PauseAnimation {
                            duration: index * 40
                        }

                        ParallelAnimation {
                            NumberAnimation {
                                target: delegate
                                property: "opacity"
                                to: 1
                                duration: 150
                                easing.type: Easing.OutCubic
                            }

                            NumberAnimation {
                                target: delegate
                                property: "scale"
                                to: 1
                                duration: 220
                                easing.type: Easing.OutBack
                            }
                        }
                    }
                   
                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 12
                        anchors.right: icon.left
                        anchors.rightMargin: 8
                        anchors.verticalCenter: parent.verticalCenter

                        text: modelData.nickname || modelData.description || modelData.name

                        color: audioOutput.palette.color.font
                        font.family: "Playpen Sans"
                        font.pixelSize: 11

                        elide: Text.ElideRight
                    }

                    Text {
                        id: icon

                        anchors.right: parent.right
                        anchors.rightMargin: 12
                        anchors.verticalCenter: parent.verticalCenter

                        text: modelData.name.startsWith("bluez_")  ? "󰋋": "󰓃"

                        color: audioOutput.palette.color.font
                        font.family: "Symbols Nerd Font"
                        font.pixelSize: 16
                    }

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            audioOutputService.setOutput(modelData)
                            outputMenu.close()
                            
                        }
                    }
                }
            }
        }
    }
}