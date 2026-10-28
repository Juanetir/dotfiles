import QtQuick
import "./services"
Item {
    id : carousel
    anchors.centerIn: parent
    property var palette: ({
            color: {
                background: "black",
                font: "red",
                border: "transparent",
                buttons: "black"
            }
        })
    property var currentIndex : 1
        
    QtObject {
        id : global
        readonly property string pathDirectory : "~/dotfiles/wallpapers/"
        readonly property int imageNumber : 3
        readonly property int imageMargin : 20
        readonly property int imageWidth : 160
        
    }

    WallpaperService {
        id : wallpaperService
    }

    function imagePosition(i, n, m, w) : int
    {
        m = m + w
        return (i - n/2)*m + (m - w) / 2 
    }

    Repeater {
        model : global.imageNumber
        
        delegate : Rectangle{
            x : imagePosition(index, global.imageNumber, global.imageMargin, global.imageWidth)
            anchors.verticalCenter: parent.verticalCenter
            width : global.imageWidth           

            ImageDisplay {
                width : global.imageWidth
                palette : carousel.palette

                imagePath : wallpaperService.wallpaperArray[(index + currentIndex - 1 + wallpaperService.wallpaperArray.length) % wallpaperService.wallpaperArray.length ]
            }
        } 
    }

    Shortcut {
        sequence: "Return"
        context: Qt.ApplicationShortcut

        onActivated: {
           wallpaperService.setWallpaper(wallpaperService.wallpaperArray[(currentIndex) % wallpaperService.wallpaperArray.length]);
        }
    }

    Shortcut {
        sequence: "Right"
        context: Qt.ApplicationShortcut

        onActivated: {
            carousel.currentIndex = (carousel.currentIndex + 1 ) % wallpaperService.wallpaperArray.length 
        }
    }
    Shortcut {
        sequence: "left"
        context: Qt.ApplicationShortcut

        onActivated: {
            carousel.currentIndex = (carousel.currentIndex + wallpaperService.wallpaperArray.length - 1 ) % wallpaperService.wallpaperArray.length 
        }
    }
}