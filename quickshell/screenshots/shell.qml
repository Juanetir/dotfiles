import Quickshell
import QtQuick
import QtQuick.Controls
import Quickshell.Io
import Quickshell.Wayland

PanelWindow {
    WlrLayershell.namespace: "screenshots"
    id : root
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    focusable: true
    visible: false

    IpcHandler {
        target: "screenshots"

        function toggle(): void {
            root.visible = !root.visible
        }

        function reloadPalette(): void {
            paletteFile.reload()
    }
    }
    Shortcut {
        sequence: "Escape"

        onActivated: {
            root.visible = false
        }
    }

    property var palette: ({
        color: {
            background: "transparent",
            font: "transparent"
        }
    })
    
    color: "transparent"

    Item { //get colores
        FileView {
            id: paletteFile

            path: "/home/tunic/.cache/palette.json"
            watchChanges: true

            onTextChanged: {
                console.log("PALETTE CHANGED")
                console.log(text())

                root.palette = JSON.parse(text())
            if (text.length === 0)
                return
            }
        }
    }
    
    property string selectedMode: "region"

    Process {
        id: screenshotProcess

        command: [
            "hyprshot",
            "-m", root.selectedMode
        ]

        running: false

        onExited: function(exitCode, exitStatus) {
            if (exitCode === 0) {
                root.visible = false
            }
        }
    }   
    function takeScreenshot(mode) {
        root.visible = false
        selectedMode = mode

        var args = [
            "hyprshot",
            "-m",
            mode
        ]

        if (screenshotName.text.length > 0) {
            args.push("-f")
            args.push(screenshotName.text + ".png")
        }

        if (clipboardSwitch.checked) {
            args.push("--clipboard-only")
        }

        screenshotProcess.command = args
        screenshotProcess.running = true
    }
    Rectangle {
        width: 300
        height: 220

        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            bottomMargin: 40
        }

        radius: 16
        color: root.palette.color.background

        Column {
            anchors.centerIn: parent
            spacing: 16
            // First row
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 8

                Rectangle {
                    width: 130
                    height: 130
                    radius: 24

                    property bool hovered: hoverHandlerRegion.hovered

                    color: hovered
                        ? Qt.alpha(root.palette.color.border, 0.8)
                        : Qt.alpha(root.palette.color.notifications, 0.63)

                    HoverHandler {
                        id: hoverHandlerRegion
                    }

                    Text {
                        anchors.centerIn: parent

                        text: ""
                        color: root.palette.color.font

                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 56
                        renderType: Text.NativeRendering
                    }

                    Text {
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 8
                        anchors.horizontalCenter: parent.horizontalCenter

                        text: "Region"
                        color: Qt.alpha(root.palette.color.font, 0.3)

                        font.family: "Playpen Sans"
                        font.weight: 500
                        font.pixelSize: 16
                    }
                    TapHandler {
                        onTapped: root.takeScreenshot("region")
                    }
                    Behavior on color {
                        ColorAnimation {
                            duration: 140
                            easing.type: Easing.OutCubic
                        }
                    }
                }

                Rectangle {
                    width: 130
                    height: 130
                    radius: 24

                    property bool hovered: hoverHandlerOutput.hovered

                    color: hovered
                        ? Qt.alpha(root.palette.color.border, 0.8)
                        : Qt.alpha(root.palette.color.notifications, 0.63)

                    HoverHandler {
                        id: hoverHandlerOutput
                    }
                    
                    Text {
                        anchors.centerIn: parent
                        text: "󱣴"
                        color: root.palette.color.font

                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 64
                        renderType: Text.NativeRendering
                    }
                    Text {
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 8
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "Output"
                        color: Qt.alpha(root.palette.color.font, 0.3)

                        font.family: "Playpen Sans"
                        font.weight: 500
                        font.pixelSize: 16
                    }
                    TapHandler {
                        onTapped: root.takeScreenshot("output")
                    }
                    Behavior on color {
                        ColorAnimation {
                            duration: 200
                        }
                    }
                }
            }

            // Second row
            Row {

                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 20

                Switch {
                    id: clipboardSwitch
                    checked : true

                    width: 54
                    height: 30
                    
                    anchors.verticalCenter: parent.verticalCenter
                    

                    indicator: Rectangle {
                        implicitWidth: 54
                        implicitHeight: 30

                        x: clipboardSwitch.leftPadding
                        y: parent.height / 2 - height / 2

                        radius: height / 2

                        color: clipboardSwitch.checked
                            ? root.palette.color.buttons
                            : Qt.alpha(root.palette.color.notifications, 1)

                        
                        Behavior on color {
                            ColorAnimation {
                                duration: 140
                                easing.type: Easing.OutCubic
                            }
                        }

                        Rectangle {
                            width: 22
                            height: 22

                            y: parent.height / 2 - height / 2
                            x: clipboardSwitch.checked
                                ? parent.width - width - 4
                                : 4

                            radius: width / 2
                            color: root.palette.color.font

                            Behavior on x {
                                NumberAnimation {
                                    duration: 140
                                    easing.type: Easing.OutCubic
                                }
                            }
                        }
                    }
                }

                TextField {
                    id: screenshotName

                    width: 200
                    height: 40

                    placeholderText: "Screenshot name"

                    font.family: "Playpen Sans"
                    font.pixelSize: 15
                    font.weight: 500

                    color: root.palette.color.font
                    placeholderTextColor: Qt.alpha(root.palette.color.font, 0.35)

                    leftPadding: 16
                    rightPadding: 16

                    background: Rectangle {
                        radius: height / 2
                        color: root.palette.color.notifications

                        border.width: 2
                        border.color: screenshotName.activeFocus? 
                            Qt.alpha(root.palette.color.border, 0.6)
                            : "transparent"

                        Behavior on border.color {
                            ColorAnimation {
                                duration: 200
                            }
                        }
                    }

                    cursorDelegate: Rectangle {
                        width: 1
                        color: root.palette.color.font
                    }
                }       
            }
        }
    }
}