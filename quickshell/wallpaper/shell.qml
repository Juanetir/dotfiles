import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Controls
import Quickshell.Io
import Quickshell.Wayland

ShellRoot {
    id: root

    property var wallpapersList: []
    property var foundWallpapers: []

    Component.onCompleted: {
        wallpaperFinder.running = true
    }
    IpcHandler {
        target: "wallpaper"

        function toggle(): void {
            window.visible = !window.visible
        }
    }

    PanelWindow {
        id: window

        WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

        anchors {
            top: true
            left: true
        }

        implicitWidth: 640
        implicitHeight: 300

        color: "#171222"

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
                wallpapersList = foundWallpapers

                if (wallpapersList.length > 0)
                    wallpaperCarousel.currentIndex =
                        Math.floor(Math.random() * wallpapersList.length)

                console.log("Loaded:", wallpapersList.length)
            }
        }

        Process {
            id: wallpaperProcess

            command: []

            stdout: SplitParser {
                onRead: data => console.log("STDOUT:", data)
            }

            stderr: SplitParser {
                onRead: data => console.log("STDERR:", data)
            }
        }
        Process {
            id: wallpaperSaveProcess
        }
        Process {
            id: sddmWallpaperProcess
        }
        Shortcut {
            sequence: "Escape"

            onActivated: {
                window.visible = false
            }
        }

        WallpaperCarousel {
            id: wallpaperCarousel

            anchors.centerIn: parent

            wallpapers: root.wallpapersList
        }

        Shortcut {
            sequence: "Left"
            context: Qt.ApplicationShortcut

            onActivated: {
                wallpaperCarousel.move(-1)
            }
        }

        Shortcut {
            sequence: "Right"
            context: Qt.ApplicationShortcut

            onActivated: {
                wallpaperCarousel.move(1)
            }
        }

        Shortcut {
            sequence: "Return"
            context: Qt.ApplicationShortcut

            onActivated: {
                if (wallpapersList.length > 0) {
                    if (!wallpaperProcess.running) {
                        let wallpaper = wallpapersList[wallpaperCarousel.currentIndex]

                        wallpaperProcess.command = [
                            "hyprctl",
                            "hyprpaper",
                            "wallpaper",
                            "eDP-1," + wallpaper
                        ]

                        wallpaperProcess.running = true

                        wallpaperSaveProcess.command = [
                            "sh",
                            "-c",
                            "printf '%s' \"$1\" > ~/.cache/current-wallpaper",
                            "--",
                            wallpaper
                        ]

                        wallpaperSaveProcess.running = true

                        sddmWallpaperProcess.command = [
                            "sh",
                            "-c",
                            "sleep 0.1 && ~/dotfiles/sddm/scripts/update-wallpaper.sh"
                        ]

                        sddmWallpaperProcess.running = true
                    }
                }
            }
        }

        HyprlandFocusGrab {
            id: focusGrab

            windows: [window]
            active: window.visible

            onCleared: {
                console.log("Focus cleared")
                window.visible = false
            }
        }
    }
}
