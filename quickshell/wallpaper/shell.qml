import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import Quickshell.Wayland

ShellRoot {
    id : wallpaperSelector

    PanelWindow {
        id: root
        WlrLayershell.namespace: "wallpaperSelector"

        anchors{
            bottom : true
        }
        exclusiveZone : 0 
        
        margins {
            bottom: 6
        }
        
        implicitWidth: 640
        implicitHeight: 300

        color: "transparent"
        focusable : true
        visible: true

    
        property var palette: ({
            color: {
                background: "black",
                font: "red",
                border: "transparent",
                buttons: "black"
            }
        })

        IpcHandler {
            target: "wallpaper"

            function toggle(): void {
                root.visible = !root.visible
            }

            function reloadPalette(): void {
                paletteFile.reload()
            }
        }

        Item {
            id: keyboardHandler
            focus: true

            anchors.fill: parent

            Keys.onEscapePressed: {
                console.log("ESC PRESSED")
                root.visible = false
            }
        }


        Item { //get colores
            FileView {
                id: paletteFile

                path: "/home/tunic/.cache/palette.json"
                watchChanges: true
                
                onTextChanged: {

                    root.palette = JSON.parse(text())
                    if (text.length === 0)
                        return
                }
                
            }
        }

        Rectangle {
            id : background
            anchors.fill: parent

            color : root.palette.color.background
            radius : 24
    
            Carousel {
                palette : root.palette
            }
        }
    }
}
