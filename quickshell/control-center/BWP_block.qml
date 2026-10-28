import Quickshell
import Quickshell.Io
import QtQuick
import "./services"

Item {
    id: root
    property int expandedMenu: -1 // -1 default as nothing

    function toggleMenu(menu) {
        if (expandedMenu === menu)
            expandedMenu = -1
        else
            expandedMenu = menu
    }

    property var palette
    implicitHeight : root.expandedMenu ===1 ? 8*12 + 3*50 : 8*5 + 3*50 
    implicitWidth : 360
    
    BluetoothService {
        id: bluetoothService
    }
    InternetService {
        id: internetService
    }
    PerformanceService {
        id: performanceService
    }

    Rectangle { //BACKGROUND
        anchors.fill: parent

        radius: root.palette.radius * 3
        color: "transparent"

        border.width: 1
        border.color: "transparent"


        Rectangle { // BWP | Menu
            anchors.top: parent.top
            anchors.right : parent.right
            anchors.rightMargin: 10
            anchors.topMargin: 10
            color : Qt.alpha(root.palette.color.border, 0.25)

            width : 300
            height : root.expandedMenu ===1 ? 8*12 + 3*50 : 8*5 + 3*50

            radius : 20    
            
            Column {
                
                anchors.centerIn: expandedMenu === -1 ?  parent : undefined
                
                anchors.horizontalCenter: expandedMenu === -1 ?  parent.horizontalCenter : undefined
                 
                spacing: 6

                Bluetooth {
                    id: bluetooth
                    palette: root.palette
                    bluetoothService: bluetoothService

                    expanded: root.expandedMenu === 0
                    visible: root.expandedMenu === -1 || root.expandedMenu === 0

                    toggleMenu: root.toggleMenu
                }

                Internet {
                    id: internet
                    palette: root.palette
                    internetService: internetService

                    expanded: root.expandedMenu === 1
                    visible: root.expandedMenu === -1 || root.expandedMenu === 1

                    toggleMenu: root.toggleMenu
                }

                Performance {
                    id: performance
                    palette: root.palette
                    performanceService: performanceService

                    expanded: root.expandedMenu === 2
                    visible: root.expandedMenu === -1 || root.expandedMenu === 2

                    toggleMenu: root.toggleMenu
                }
            }

        }
    }
}