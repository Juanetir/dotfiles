import QtQuick
import QtQuick.Controls
import Quickshell

import "./services"



Rectangle {
    id: pcdata
    

    QtObject {
        id: colors

        property color ram: '#e993ef'
        property color cpu: '#85d8ef'
        property color gpu: '#92ecb3'
    }
    
    width: 130
    height: 130
    radius: 16
    border.width: 2
    
    property var palette
    property var statShown : 1
    
    MouseArea {
        anchors.fill : parent
        onClicked: {
            statShown = (statShown + 1) % 3

            console.log("values : ", cpuService.usage, ramService.usage, gpuService.usage)
        }
    }
    /*
        COLORS
    */
   color: {
        const alpha = 0.15

        let color

        if (pcdata.statShown === 0) {
            color = colors.cpu
        } else if (pcdata.statShown === 1) {
            color = colors.ram
        } else if (pcdata.statShown === 2) {
            color = colors.gpu
        }

        return Qt.alpha(color, alpha)
    }
    border.color : {
        const alpha = 0.34

        let color

        if (pcdata.statShown === 0) {
            color = colors.cpu
        } else if (pcdata.statShown === 1) {
            color = colors.ram
        } else if (pcdata.statShown === 2) {
            color = colors.gpu
        }

        return Qt.alpha(color, alpha)
    }

   /*
        Services
   */
    CPUService {
        id: cpuService
    }

    RAMService {
        id: ramService
    }

    GPUService {
        id: gpuService
    }

    /*
        Text
    */
    Text {
        id : statText
        anchors.centerIn: parent
         
        text: {
            if (pcdata.statShown === 0) {
                return Math.round(cpuService.usage)
            } else if (pcdata.statShown === 1) {
                return Math.round(ramService.usage)
            } else if (pcdata.statShown === 2) {
                return Math.round(gpuService.usage)
            }
        }

        font.pixelSize: 24
        color: pcdata.color

        onTextChanged: {
            numberAnimation.restart()
        }

        SequentialAnimation {
            id: numberAnimation

            NumberAnimation {
                target: statText
                property: "scale"
                to: 0.4
                duration: 80
            }

            NumberAnimation {
                target: statText
                property: "scale"
                to: 1
                duration: 120
                easing.type: Easing.OutCubic
            }
        }
    }

    Behavior on color {
        ColorAnimation {
            duration: 140
        }
    }
    /*
        DRAW circle
    */
    Canvas {
        id: gauge

        property real marg : 16
        x: marg/2
        y: marg/2
        width: pcdata.width - marg
        height: pcdata.height - marg

        property real value: pcdata.statShown === 0 ? cpuService.usage / 100
            : pcdata.statShown === 1 ? ramService.usage / 100
            : pcdata.statShown === 2 ? gpuService.usage / 100
            : 0
        property color backgroundColor: Qt.alpha(pcdata.palette.color.background, 0.5)
        property color foregroundColor: {
            const alpha = 0.32

            let color

            if (pcdata.statShown === 0) {
                color = colors.cpu
            } else if (pcdata.statShown === 1) {
                color = colors.ram
            } else if (pcdata.statShown === 2) {
                color = colors.gpu
            }

            return Qt.alpha(color, alpha)
        }
        property real thickness: 8

        onValueChanged: requestPaint()
        onPaint: {
            const ctx = getContext("2d")

            ctx.reset()

            const centerX = width / 2
            const centerY = height / 2
            const radius = (Math.min(width, height) - thickness) / 2

            // Background circle
            ctx.beginPath()
            ctx.arc(
                centerX,
                centerY,
                radius,
                0,
                2 * Math.PI
            )
            ctx.lineWidth = thickness
            ctx.strokeStyle = backgroundColor
            ctx.stroke()

            // Value arc
            ctx.beginPath()
            ctx.arc(
                centerX,
                centerY,
                radius,
                -Math.PI / 2,
                -Math.PI / 2 + value * 2 * Math.PI
            )
            ctx.lineWidth = thickness
            ctx.strokeStyle = foregroundColor
            ctx.lineCap = "round"
            ctx.stroke()
        }

        Behavior on value {
            NumberAnimation {
                duration: 300
                easing.type: Easing.OutCubic
            }
        }
    }
}