import QtQuick

Rectangle {
    id: performance

    width: 260
    height: 50

    radius: 14

    property var palette
    property var performanceService
    property bool expanded: false

    property var toggleMenu
    
    color: {
        if (performanceService.profile === "performance")
            return Qt.alpha("#fd0b0b", 0.30)

        if (performanceService.profile === "balanced")
            return Qt.alpha("#fccb19", 0.30)

        return Qt.alpha("#3cff00", 0.17)
    }

    border.width: 1

    border.color: {
        if (performanceService.profile === "performance")
            return Qt.alpha("#9c0a36", 0.2)

        if (performanceService.profile === "balanced")
            return Qt.alpha("#d8b906", 0.2)

        return Qt.alpha("#059149", 0.2)
    }
    Behavior on color {
                ColorAnimation {
                    duration: 300
                }
            }
    MouseArea { // Toggle Menu
            anchors.fill: parent

            onClicked: {
                performance.expanded = !performance.expanded
                performance.toggleMenu(2)

            }
        }
    
    HoverHandler {
        onHoveredChanged: {
            parent.hovered = hovered
        }
    }
    // 
    // Main Button
    // 

    Row {
        anchors.fill: parent

        anchors.leftMargin: 14
        anchors.rightMargin: 14

        spacing: 8
        
        Text {
            width: parent.width - icon.width - 20

            anchors.verticalCenter: parent.verticalCenter

            text: {
                if (performance.performanceService.profile === "performance")
                    return "Performance"

                if (performance.performanceService.profile === "balanced")
                    return "Balanced"

                return "Low Power"
            }

            color: performance.palette.color.font

            font.pixelSize: 14
            font.family: "Playpen Sans"

            elide: Text.ElideRight
        }

        Rectangle {
            id: icon

            color: "transparent"

            radius: 10

            width: 40
            height: 40

            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: -4
            
            Text {
                anchors.centerIn: parent

                text: {
                    if (performance.performanceService.profile === "performance")
                        return "󰈸"

                    if (performance.performanceService.profile === "balanced")
                        return "󰾆"

                    return "󰌪"
                }

                color: performance.palette.color.font

                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 24

                renderType: Text.NativeRendering
            }
        } 
    }

    // ─────────────────────────
    // Dropdown
    // ─────────────────────────

    Column {
        anchors.top: parent.top
        anchors.topMargin: 55

        width: parent.width

        visible: performance.expanded

        spacing: 4

        Rectangle {
            property bool hovered: false
            width: parent.width - 20
            height: 32

            anchors.horizontalCenter: parent.horizontalCenter
            color: Qt.alpha(
                root.palette.color.border,
                hoverHandlerLP.hovered ? 0.30 : 0.20
            )
            Behavior on color {
                ColorAnimation {
                    duration: 200
                }
            }
            

            radius: 10
            HoverHandler {
                id: hoverHandlerLP
            }
            Text {
                anchors.centerIn: parent

                text: "Low power"

                color: performance.palette.color.font
                font.family: "Playpen Sans"
                font.pixelSize: 13
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    performance.performanceService.setProfile("power-saver")
                    performance.expanded = false
                    performance.toggleMenu(2)
                }
            }
        }

        Rectangle {
            property bool hovered: false
            width: parent.width - 20
            height: 32
            anchors.horizontalCenter: parent.horizontalCenter

            color: Qt.alpha(
                root.palette.color.border,
                hoverHandlerB.hovered ? 0.30 : 0.20
            )
            Behavior on color {
                ColorAnimation {
                    duration: 200
                }
            }

            radius: 10
            HoverHandler {
                id: hoverHandlerB
                }

            Text {
                anchors.centerIn: parent

                text: "Balanced"

                color: performance.palette.color.font
                font.family: "Playpen Sans"
                font.pixelSize: 13
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    performance.performanceService.setProfile("balanced")
                    performance.expanded = false
                    performance.toggleMenu(2)
                }
            }
        }

        Rectangle {
            property bool hovered: false
            width: parent.width - 20
            height: 32
            anchors.horizontalCenter: parent.horizontalCenter

            color: Qt.alpha(
                root.palette.color.border,
                hoverHandlerP.hovered ? 0.30 : 0.20
            )

            radius: 10
            HoverHandler {
                id: hoverHandlerP
            }

            Text {
                anchors.centerIn: parent

                text: "Performance"

                color: performance.palette.color.font
                font.family: "Playpen Sans"
                font.pixelSize: 13
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    performance.performanceService.setProfile("performance")
                    performance.expanded = false
                    performance.toggleMenu(2)
                }
            }
        }
    }
}