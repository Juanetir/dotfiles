import QtQuick 2.15
import QtQuick.Controls 2.15
import ".."

Item {
    id: root

    width: 44
    height: 44

    property bool menuOpen: false

    Theme {
        id: theme
    }

    // Botón principal: solo muestra el icono.
    Rectangle {
        id: powerButton

        anchors.top: parent.top
        anchors.right: parent.right
        width: 44
        height: 44
        radius: 22

        color: powerMouse.containsMouse
               ? "#292b3a"
               : "transparent"

        Behavior on color {
            ColorAnimation { duration: 120 }
        }

        Text {
            anchors.centerIn: parent

            // Nerd Font: Power
            text: "󰐥"
            font.family: theme.iconFont
            font.pixelSize: 22
            color: theme.text
        }

        MouseArea {
            id: powerMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onClicked: root.menuOpen = !root.menuOpen
        }
    }

    // Menú desplegable.
    Rectangle {
        id: menu

        anchors.top: powerButton.bottom
        anchors.right: powerButton.right
        anchors.topMargin: 8

        width: 156
        height: menuOpen ? 100 : 0
        radius: 12
        color: "#292b3a"
        clip: true
        visible: height > 0

        Behavior on height {
            NumberAnimation {
                duration: 140
                easing.type: Easing.OutCubic
            }
        }

        Column {
            anchors.fill: parent
            anchors.margins: 6
            spacing: 2

            // Reiniciar.
            Rectangle {
                width: parent.width
                height: 42
                radius: 8
                color: restartMouse.containsMouse
                       ? "#414253"
                       : "transparent"

                Row {
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    spacing: 10

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right : parent.right
                        anchors.rightMargin: 15
                        text: "󰜉"
                        font.family: theme.iconFont
                        font.pixelSize: 20
                        color: theme.text
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "restart"
                        font.family: theme.iconFont
                        font.pixelSize: 14
                        color: theme.text
                    }
                }

                MouseArea {
                    id: restartMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        root.menuOpen = false
                        sddm.reboot()
                    }
                }
            }

            // Apagar.
            Rectangle {
                width: parent.width
                height: 42
                radius: 8
                color: shutdownMouse.containsMouse
                       ? "#414253"
                       : "transparent"

                Row {
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    spacing: 10

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right : parent.right
                        anchors.rightMargin: 15
                        text: "󰐥"
                        font.family: theme.iconFont
                        font.pixelSize: 18
                        color: theme.text
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "off"
                        font.family: theme.iconFont
                        font.pixelSize: 14
                        color: theme.text
                    }
                }

                MouseArea {
                    id: shutdownMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        root.menuOpen = false
                        sddm.powerOff()
                    }
                }
            }
        }
    }
}