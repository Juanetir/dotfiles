//
// [maya] components/SpClock.qml
//
// Implements custom clock component
//
// (c) 2016 Sanjeev Premi (spremi@ymail.com)
//
// SPDX-License-Identifier: MIT
//                          (https://spdx.org/licenses/MIT.html)
//


import QtQuick 2.0

Item {
    id: sp_clock

    property date value: new Date()

    property color tColor: "white"
    property alias tFont: sp_clock_text.font

    Timer {
        interval: 1000
        running: true
        repeat: true

        onTriggered: sp_clock.value = new Date()
    }

        Text {
        id: sp_clock_text_shadow

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        height: 150

        text: Qt.formatDateTime(
            sp_clock.value,
            "HH:mm"
        )

        color: "#000000"

        font.family: playpen_sans.name
        font.pixelSize: 164

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
    Text {
        id: sp_clock_text

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        height: 150

        text: Qt.formatDateTime(
            sp_clock.value,
            "HH:mm"
        )

        color: sp_clock.tColor

        font.family: playpen_sans.name
        font.pixelSize: 158

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }


    Text {
        id: sp_date_text

        anchors {
            top: sp_clock_text.bottom
            left: parent.left
            right: parent.right
        }
        height: 30

        text: Qt.formatDateTime(
            sp_clock.value,
            "dddd d MMMM"
        )

        color: "#CCFFFFFF"

        font.family: playpen_sans.name
        font.pixelSize: 16

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}