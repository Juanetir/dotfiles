import Quickshell.Io
import QtQuick
import Quickshell

Scope {
    id : selector

    property var wallpaperArray : []
    property var found : []
    property var wallpaperCurrent : ""

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
                found.push(data)
            }
        }
        onExited: if (found.length > 0) {
            console.log("Loaded:", found.length)
            wallpaperArray = found
        }
    }

    Process {
        id : wallpaperGetCurrent

        command : [
            "cat", 
            "/home/tunic/.cache/current-wallpaper" 
        ]
        stdout: SplitParser {
            onRead: data => {
                wallpaperCurrent = data
                console.log("Current : ", wallpaperCurrent)
            }
        }
    }

    Process {
        id : wallpaperSetWallpaper
    }

    Process {
        id : wallpaperUpdateWallpaper
    }

    Process {
        id : wallpaperUseWallpaper
    }
    function setWallpaper(path){
        wallpaperSetWallpaper.command = [
            "sh", "-c",
            "printf '%s' \"$1\" > ~/.cache/current-wallpaper",
            "--",
            path
        ]
        wallpaperSetWallpaper.running = true

        
        wallpaperUpdateWallpaper.command = [
            "sh",
            "-c",
            "~/dotfiles/scripts/update-wallpaper.sh"
        ]

        wallpaperUpdateWallpaper.running = true

        wallpaperUseWallpaper.command = [
        "awww", "img",
        path,
        "--transition-type", "random",
        "--transition-duration", "1",
        "--transition-fps", "60",
        "--transition-step", "90",
        "--resize", "crop",
        "--crop-gravity", "center",
        "--filter", "Lanczos3"
    ]
        wallpaperUseWallpaper.running = true
    }
        
    Component.onCompleted: {
        wallpaperGetCurrent.running = true
        wallpaperFinder.running = true
    } 
    

}