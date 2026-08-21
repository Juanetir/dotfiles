import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Controls
import Quickshell.Io
import Quickshell.Wayland

ShellRoot {
    property var wallpapers: []
    property var foundWallpapers: []
    property var filteredWallpapers: []
    property int currentIndex: 0

    Component.onCompleted: {
        wallpaperFinder.running = true
    }

    PanelWindow {
        id: window
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

        anchors {
            top: true
            left: true
        }

        implicitWidth: 640
        implicitHeight: 300

        color: "#202020"
        TextField {
            id: var_wallpaperSearch
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            width: 200
            placeholderText: "Type something..."
            focus: trueWallpaperCarousel {
    wallpapers: filteredWallpapers
    currentIndex: currentIndex
}

            Keys.onLeftPressed: {
                currentIndex = (currentIndex - 1 + filteredWallpapers.length) % filteredWallpapers.length
            }

            Keys.onRightPressed: {
                currentIndex = (currentIndex + 1) % filteredWallpapers.length
            }
            onAccepted: {
                wallpaperProcess.command = [
                    "hyprctl",
                    "hyprpaper",
                    "wallpaper",
                    "eDP-1," + filteredWallpapers[currentIndex]
                ]

                wallpaperProcess.running = true
            }
            onTextChanged: {
                filteredWallpapers = wallpapers.filter(function(path) {
                    return path.toLowerCase().includes(text.toLowerCase())
                })

                currentIndex = 0
            }
        }
          Process {
            id: wallpaperFinder

            command: [
                "find",
                "/home/tunic/dotfiles/wallpapers",
                "-type", "f",
                "(",
                "-name", "*.png",
                "-o",
                "-name", "*.jpg",
                "-o",
                "-name", "*.jpeg",
                ")"
            ]

            stdout: SplitParser {
                onRead: data => {
                    foundWallpapers.push(data)
                }
            }

            onExited: {
                wallpapers = foundWallpapers
                filteredWallpapers = foundWallpapers
                console.log("Loaded:", wallpapers.length)
            }
        }
        Process {
            id: wallpaperProcess

            command: [
                "hyprctl",
                "hyprpaper",
                "wallpaper",
                "eDP-1,/home/tunic/dotfiles/wallpapers/" + var_wallpaperSearch.text
            ]

            stdout: SplitParser {
                onRead: data => console.log("STDOUT:", data)
            }

            stderr: SplitParser {
                onRead: data => console.log("STDERR:", data)
            }
        }
        
        Row {
            anchors.centerIn: parent
            spacing: 20
            visible: filteredWallpapers.length > 0
            Image {
                width: 200
                height: 266
                source: filteredWallpapers[(currentIndex - 1 + filteredWallpapers.length) % filteredWallpapers.length]
                fillMode: Image.PreserveAspectFit
            }

            Column {
                spacing: 5

                Image {
                    width: 200
                    height: 266
                    source: filteredWallpapers[currentIndex]
                    fillMode: Image.PreserveAspectFit
                }

                Text {
                    text: filteredWallpapers[currentIndex].split("/").pop()
                    width: 200
                    horizontalAlignment: Text.AlignHCenter
                    elide: Text.ElideMiddle
                }
            }

            Image {
                width: 200
                height: 266
                source: filteredWallpapers[(currentIndex + 1) % filteredWallpapers.length]
                fillMode: Image.PreserveAspectFit
            }
        }
        Shortcut {
            sequence: "Escape"

            onActivated: {
                window.visible = false
            }
        }
        Shortcut {
            sequence: "Left"

            onActivated: {
                currentIndex = (currentIndex - 1 + wallpapers.length) % wallpapers.length
            }
        }

        Shortcut {
            sequence: "Right"

            onActivated: {
                currentIndex = (currentIndex + 1) % wallpapers.length
            }
        }

        HyprlandFocusGrab {
            id: focusGrab

            windows: [window]
            active: window.visible

            onCleared: {
                window.visible = false
            }
        }
    }
}

