import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import Quickshell.Wayland

ShellRoot {
    id : controlCenter

    PanelWindow {
        id: root
        WlrLayershell.namespace: "control-center"
        anchors {
            top: true
            right: true
        }
        margins {
            top: 12
            right: 12
        }
        
        implicitWidth: 480
        implicitHeight: 350

        color: "transparent"
        focusable : true
        visible: false
        // focus: true
        // activeFocusOnTab: true

            

        property var palette: ({
            color: {
                background: "black",
                font: "border",
                border: "transparent",
                buttons: "black"
            }
        })
        Item {
            id: keyboardHandler
            focus: true

            anchors.fill: parent

            Keys.onEscapePressed: {
                console.log("ESC PRESSED")
                root.visible = false
            }
        }
        IpcHandler {
            target: "control-center"

            function close(): void {
                root.visible = false
            }

            function open(): void {
                root.visible = true
            }
             function toggleQuick(): void {
                if (root.visible)
                    close()
                else
                    open()
            }
            
            function reloadPalette(): void {
            paletteFile.reload()
    }
        }
        Item {
            FileView {
                id: paletteFile

                path: "/home/tunic/.cache/palette.json"
                watchChanges: true

                onTextChanged: {
                    root.palette = JSON.parse(text())
                }
            }
        }
        Rectangle {
            width: 480
            height: 350

            radius: root.palette.radius * 3
            color: root.palette.color.background

            Column {
                anchors.top: parent.top
                anchors.right: parent.right

                anchors.topMargin: 15
                anchors.rightMargin: 15

                spacing: 12
                
                BWP_block {
                    id : bwp
                    palette: root.palette
                }

                Brightness {
                    width : 300
                    anchors.right: parent.right
                    anchors.rightMargin :10
                    palette: root.palette
                }

                Volume {
                    width: 300
                    anchors.right: parent.right
                    anchors.rightMargin :10
                    height: 10
                    palette: root.palette
                }

                AudioOutput { 
                    anchors.right: parent.right
                    anchors.rightMargin: -20

                    palette : root.palette
                }
                
                
            }
            
                
            Column {
                anchors.top: parent.top
                anchors.left: parent.left

                anchors.topMargin: 15
                anchors.leftMargin: 15
                Caffeine {
                    palette: root.palette
                }
            }

            PCdata {
                anchors.bottom: parent.bottom
                anchors.left: parent.left

                anchors.bottomMargin: 15
                anchors.leftMargin: 15

                palette: root.palette
            }

        }
    }

}