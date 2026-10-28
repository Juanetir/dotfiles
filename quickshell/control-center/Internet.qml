import QtQuick

Rectangle {
    id: internet

    width: 260
    height: 50

    radius: 14

    property var palette
    property var internetService
    property bool expanded: false
    property bool passwordMode: false
    property string selectedNetwork: ""

    property var toggleMenu

    color: {
        if (!internet.internetService.wifiEnabled)
            return Qt.alpha(internet.palette.color.border, 0.09)

        if (!internet.internetService.connected)
            return Qt.alpha(internet.palette.color.buttons, 0.13)

        return Qt.alpha(internet.palette.color.buttons, 0.3)
    }

    border.width: 1
    border.color: Qt.alpha(
        internet.palette.color.border,
        0.10
    )
    
    MouseArea {
        anchors.fill: parent
        
        onClicked: {
            internet.expanded = !internet.expanded
            if (internet.passwordMode) {
                internet.passwordMode = false
                internet.expanded = false}
            internet.toggleMenu(1)
       }
    }
    
    Row {
        anchors.fill: parent

        anchors.leftMargin: 14
        anchors.rightMargin: 14

        spacing: 8

        Text {
            width: parent.width - icon.width - 20

            anchors.verticalCenter: parent.verticalCenter

            text: {
                if (!internet.internetService.wifiEnabled)
                    return "Dead"

                if (!internet.internetService.connected)
                    return "Searching . . ."

                return internet.internetService.ssid
            }
            
            color: internet.palette.color.font

            font.pixelSize: 14
            font.family: "Playpen Sans"

            elide: Text.ElideRight
        }

        Rectangle {
            id: icon

            color: Qt.alpha(
                internet.palette.color.border,
                0.60
            )

            radius: 10

            width: 40
            height: 40

            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: -4

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    internetService.toggle()
                }
            }

            Text {
                anchors.centerIn: parent

                text: !internet.internetService.wifiEnabled
                    ? "󰖪"
                    : "󰖩"

                color: internet.palette.color.font

                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 24

                renderType: Text.NativeRendering
            }
        }
    }
        //     
        //  Scrollable Menu | Internet
        //     
    Item {
        anchors.top: parent.top
        anchors.topMargin: 55

        width: parent.width
        height: 140

        clip: true

        visible : internet.expanded

        ListView {
            id: networkList

            anchors.fill: parent

            model: internetService.networks

            spacing: 4

            boundsBehavior: Flickable.StopAtBounds

            delegate: Rectangle {
                width: ListView.view.width - 20
                height: 36

                radius: 10

                HoverHandler {
                    id: hoverHandler
                }

                color: {
                    const connected =
                        internet.internetService.ssid === modelData.ssid

                    const alpha = connected
                        ? (hoverHandler.hovered ? 0.50 : 0.40)
                        : (hoverHandler.hovered ? 0.30 : 0.20)

                    return Qt.alpha(
                        internet.palette.color.border,
                        alpha
                    )
                }
                Behavior on color {
                    ColorAnimation {
                        duration: 200
                    }
                }

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    anchors.verticalCenter: parent.verticalCenter

                    text: modelData.ssid

                    color: internet.palette.color.font
                    font.family: "Playpen Sans"
                    font.pixelSize: 13

                    elide: Text.ElideRight
                }

                Text {
                    anchors.right: parent.right
                    anchors.rightMargin: 12
                    anchors.verticalCenter: parent.verticalCenter

                    text: modelData.signal + "%"

                    color: internet.palette.color.font
                    font.family: "Playpen Sans"
                    font.pixelSize: 11
                }

                MouseArea {
                    anchors.fill: parent
                    Timer {
                        id: passwordFocusTimer

                        interval: 0
                        repeat: false

                        onTriggered: passwordInput.forceActiveFocus()
                    }
                    onClicked: { // CONECTARSE A INTERNET
                        if (modelData.security === "") { // NO Security | just connect
                            internet.internetService.connectWifi(
                                modelData.ssid,
                                ""
                            )
                            return
                        }

                        if (internet.internetService.isSavedNetwork(modelData.ssid)) { // Has security & already used | connect
                            internet.internetService.connectWifi(
                                modelData.ssid,
                                ""
                            )
                            return
                        }
                        // Has security & dont know password | ASK 
                        internet.selectedNetwork = modelData.ssid
                        internet.passwordMode = true
                        internet.expanded = false
                        passwordFocusTimer.start()
                    }
                }
            }
        }
    }
        //
        //  Password Write menu :
        //
    Item {
        anchors.top: parent.top
        anchors.topMargin: 65

        width: parent.width
        height: 100

        visible: internet.passwordMode

        Text {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 0

            text: internet.selectedNetwork

            color: internet.palette.color.font
            font.family: "Playpen Sans"
            font.pixelSize: 14
        }

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: 32

            height: 40
            radius: 10

            color: Qt.alpha(
                internet.palette.color.font,
                0.10
            )

            TextInput {
                id: passwordInput

                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12

                verticalAlignment: TextInput.AlignVCenter

                text: ""

                color: internet.palette.color.font
                font.family: "Playpen Sans"
                font.pixelSize: 13

                echoMode: TextInput.Password

                focus: internet.passwordMode

                clip: true

                // onVisibleChanged: {
                //     if (visible)
                //         forceActiveFocus()
                // }

                Keys.onPressed: event => {
                    if (event.key === Qt.Key_Backspace && text === "") {
                        internet.passwordMode = false
                        internet.expanded = true
                        event.accepted = true
                    }

                    if (event.key === Qt.Key_Return ||
                        event.key === Qt.Key_Enter) {

                        internet.internetService.connectWifi(
                            internet.selectedNetwork,
                            text
                        )

                        internet.expanded = true
                        internet.passwordMode = false
                    }
                }
            }
        }
    }
}