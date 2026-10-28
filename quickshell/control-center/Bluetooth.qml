import QtQuick



    //
    //*  Main Button
    //

Rectangle {
    id: bluetooth

    width: 260
    height: 50

    radius: 14

    property var palette
    property var bluetoothService
    property bool expanded: false


    property var toggleMenu

    color: bluetooth.bluetoothService.powered
        ? Qt.alpha(bluetooth.palette.color.buttons, 0.3)
        : Qt.alpha(bluetooth.palette.color.border, 0.09)

    border.width: 1
    border.color: Qt.alpha(
        palette.color.border,
        0.10
    )
    MouseArea {
        anchors.fill : parent

        onClicked : {
            bluetooth.expanded = !bluetooth.expanded
            bluetooth.toggleMenu(0)
        }
    }

    //
    //*  Right Toogle Button
    //


    Row {
        anchors.fill: parent

        anchors.leftMargin: 14
        anchors.rightMargin: 14

        spacing: 8

        Text {
            width: parent.width - icon.width - 50

            anchors.verticalCenter: parent.verticalCenter

            text: {
                const devices = bluetooth.bluetoothService.connectedDevice

                console.log("TEXT DEVICES:", JSON.stringify(devices))
                console.log("FIRST:", JSON.stringify(devices[0]))
                console.log("NAME:", devices[0]?.name)

                if (devices.length === 0)
                    return "Bluetooth"

                if (devices.length === 1)
                    return devices[0]?.name ?? "Bluetooth"

                return (devices[0]?.name ?? "Bluetooth") + " +" + (devices.length - 1)
            }

            color: bluetooth.palette.color.font

            font.pixelSize: 14
            font.family: "playpen sans"

            elide: Text.ElideRight
        }

        Rectangle {
            id: icon

            color: Qt.alpha(bluetooth.palette.color.border, 0.60)
            radius : 10

            width: 40
            height: 40

            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: -4

            MouseArea {
                anchors.fill: parent

                onClicked: bluetoothService.toggle()
            }
        
            Text {
                anchors.centerIn: parent
                             
                text: bluetooth.bluetoothService.powered
                    ? "󰂯"
                    : "󰂲"

                color: bluetooth.palette.color.font

                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 24

                renderType: Text.NativeRendering
            }
        }
    }

    /*
        SCROLLABLE MENU    
    */
    HoverHandler {
        onHoveredChanged: {
            parent.hovered = hovered
        }
    }
    ListView {
        anchors.top: parent.top
        anchors.topMargin: 55

        width: parent.width + 5
        height: 150

        model: bluetoothService.devices

        visible : bluetooth.expanded
        spacing : 4
        delegate: Rectangle {
            width: ListView.view.width - 20
            height: 36

            radius: 10

            property bool hovered: false


            HoverHandler {
                id: hoverHandler
            }
            color: {
                const connected = bluetooth.bluetoothService.connectedDevice
                    .some(device => device.mac === modelData.mac)

                const alpha = connected
                    ? (hoverHandler.hovered ? 0.50 : 0.40)
                    : (hoverHandler.hovered ? 0.30 : 0.20)

                return Qt.alpha(
                    bluetooth.palette.color.border,
                    alpha
                )
            }
            Behavior on color {
                ColorAnimation {
                    duration: 300
                }
            }
            Text {
                anchors.left: parent.left
                anchors.leftMargin: 12
                anchors.verticalCenter: parent.verticalCenter

                text: modelData.name

                color: root.palette.color.font
                font.family: "Playpen Sans"
                font.pixelSize: 13
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    bluetooth.bluetoothService.toggleDevice(
                        modelData.mac
                    )
                }
            }
        }
    }
}
