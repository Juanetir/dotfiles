
import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import ".."

Item {
    id: root

    width: theme.loginCardWidth
    implicitHeight: card.height

    visible : false
    signal closed()
    
    // Theme.qml está en la carpeta padre.
    Theme {
        id: theme
    }
    function attemptLogin() {
        if (passwordField.text.length === 0)
            return

        console.log("1. attemptLogin ejecutado")
        console.log("2. Usuario: tunic")
        console.log("3. Índice de sesión:", sessionModel.lastIndex)

        sddm.login("tunic", passwordField.text, sessionModel.lastIndex)

        console.log("4. Llamada a sddm.login realizada")
    }
    
    Rectangle {
        id: card

        width: parent.width
        height: content.implicitHeight + theme.spacingXL * 2

        color: Qt.rgba(
            theme.surface.r,
            theme.surface.g,
            theme.surface.b,
            theme.cardOpacity
        )
        radius: theme.radiusLarge
        border.width: 1
        border.color: theme.borderSubtle

        Column {
            id: content

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: theme.spacingXL

            spacing: theme.spacingM

            // Avatar circular
            Item {
                id: avatarFrame

                width: theme.avatarSize
                height: theme.avatarSize
                anchors.horizontalCenter: parent.horizontalCenter

                Rectangle {
                    anchors.fill: parent
                    radius: width / 2
                    color: theme.surfaceElevated
                    border.width: 2
                    border.color: theme.accent
                }

                
                Loader {
                    id: avatarLoader

                    anchors.fill: parent
                    anchors.margins: 3

                    source: Qt.resolvedUrl("../assets/avatar.qml")

                    // Recorte circular
                    layer.enabled: true
                    layer.effect: OpacityMask {
                        maskSource: Rectangle {
                            width: avatarLoader.width
                            height: avatarLoader.height
                            radius: width / 2
                        }
                    }
                }

            }

            // Nombre de usuario
            Text {
                anchors.horizontalCenter: parent.horizontalCenter

                text: "tunic"
                color: Qt.alpha(theme.text, 0.5)
                font.family: theme.fontFamily
                font.pixelSize: 16
                font.weight: Font.Medium
            }

            // Campo de contraseña
            TextField {
                id: passwordField

                width: parent.width
                height: theme.inputHeight
                
                horizontalAlignment: Qt.AlignHCenter

                placeholderText: "Password"
                echoMode: TextInput.Password
                color: theme.text
                placeholderTextColor: theme.placeholder
                font.family: theme.fontFamily
                font.pixelSize: 14
                leftPadding: theme.spacingM
                rightPadding: theme.spacingM
                selectByMouse: true
                focus: root.visible

                background: Rectangle {
                    color: theme.inputOpacity > 0
                        ? Qt.rgba(
                            theme.surfaceElevated.r,
                            theme.surfaceElevated.g,
                            theme.surfaceElevated.b,
                            theme.inputOpacity
                          )
                        : "transparent"

                    radius: theme.radiusLarge
                    border.width: passwordField.activeFocus ? 3 : 2
                    border.color: passwordField.activeFocus
                        ? theme.accent
                        : theme.borderSubtle
                }
                
                               
                Keys.onReturnPressed: root.attemptLogin()
                Keys.onEnterPressed: root.attemptLogin()
                Keys.onPressed: (event) => {
                    if (event.key === Qt.Key_Escape) {
                        // root.visible = false
                        root.closed()
                        event.accepted = true
                    }
                    if (event.key === Qt.Key_Backspace && passwordField.text.length === 0) {
                        // root.visible = false
                        root.closed()
                        event.accepted = true
                    }
                }

            }
            Text {
                id: errorText

                width: parent.width
                text: "Wrong!"
                color: "#E89AAE"
                horizontalAlignment: Text.AlignHCenter
                visible: false

                font.family: theme.fontFamily
                font.pixelSize: 12
            }
        }
        Connections {
            target: sddm

            function onLoginFailed() {
                passwordField.text = ""

                errorText.visible = true

                shakeAnimation.stop()
                root.rotation = 0
                shakeAnimation.start()
            }
        }
        SequentialAnimation {
            id: shakeAnimation

            NumberAnimation {
                target: root
                property: "rotation"
                to: -2.5
                duration: 40
            }
            NumberAnimation {
                target: root
                property: "rotation"
                to: 2.5
                duration: 40
            }
            NumberAnimation {
                target: root
                property: "rotation"
                to: -2
                duration: 40
            }
            NumberAnimation {
                target: root
                property: "rotation"
                to: 1.5
                duration: 40
            }
            NumberAnimation {
                target: root
                property: "rotation"
                to: 0
                duration: 40
            }
        }
    }
}
