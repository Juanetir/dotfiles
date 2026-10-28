
import QtQuick 2.15
import ".."

Item {
    id: root

    implicitWidth: clockText.implicitWidth
    implicitHeight: clockText.implicitHeight

    // Actualiza la hora cada segundo.
    property string currentTime: Qt.formatTime(new Date(), "HH:mm")

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.currentTime = Qt.formatTime(new Date(), "HH:mm")
    }

    // Hora principal con contorno oscuro.
    Text {
        id: clockText

        anchors.centerIn: parent
        text: root.currentTime

        font.family: theme.fontFamily
        font.pixelSize: 300
        font.weight: 500

        color: theme.text
        // style: Text.Outline
        // styleColor: "#11131C"
        
    }

    Theme {
        id: theme
    }
}
