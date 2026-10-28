
import QtQuick 2.15
import "./components"
Rectangle {
    id: root

    width: Screen.width
    height: Screen.height

    color: theme.background

    property var isLogin : false
    
    Theme {
        id: theme
    }

    Image {
        id: wallpaper

        anchors.fill: parent
        source: Qt.resolvedUrl("assets/wallpaper.png")
        fillMode: Image.PreserveAspectCrop
        asynchronous: false
        cache: true
    }
    Item {
        id: keyHandler

        anchors.fill: parent
        focus: true

        Keys.onPressed: (event) => {
            if (!root.isLogin && event.key != Qt.Key_Escape) {
                root.isLogin = true
                event.accepted = true
            }
            else if (event.key === Qt.Key_Escape) {
                root.isLogin = false
                keyHandler.forceActiveFocus()
                event.accepted = true
            }
        }
    }
    MenuPower {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 24
        anchors.rightMargin: 24
        z: 100
    }
    Clock {
        id: clock

        anchors.centerIn: parent
        visible: !isLogin

        opacity: 1
        scale: root.isLogin ? 0.92 : 1.0
        y: root.isLogin ? -35 : 0

        Behavior on scale {
            NumberAnimation {
                duration: 250
                easing.type: Easing.OutCubic
            }
        }

        Behavior on y {
            NumberAnimation {
                duration: 300
                easing.type: Easing.OutCubic
            }
        }

        states: State {
            name: "hidden"
            when: root.isLogin
            PropertyChanges {
                target: clock
                opacity: 0
            }
        }

        transitions: Transition {
            NumberAnimation {
                properties: "opacity"
                duration: 150
            }
        }
    }
    LoginCard {
        id: loginCard

        visible: isLogin
        anchors.centerIn: parent

        opacity: 1
        scale: root.isLogin ? 1.0 : 0.94

        transform: Translate {
            y: root.isLogin ? 0 : 35
        }

        Behavior on scale {
            NumberAnimation {
                duration: 350
                easing.type: Easing.OutBack
                easing.overshoot: 1.1
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: 150
            }
        }

        onClosed: {
            root.isLogin = false
            keyHandler.forceActiveFocus()
        }
    }



    // Clock {
    //     anchors.centerIn: parent
    //     visible : !root.isLogin
    // }

    // LoginCard {
    //     id: loginCard

    //     visible: root.isLogin
    //     anchors.centerIn: parent

    //     onClosed: {
    //         root.isLogin = false
    //         keyHandler.forceActiveFocus()
    //     }
    // }
}
