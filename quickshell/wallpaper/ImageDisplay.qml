import QtQuick

Item {
    id : image
    anchors.centerIn: parent
    property var imagePath

    property var palette
    Item{
        anchors.centerIn: parent
        
        width: image.width 
        height: image.width * 1.35

        clip : true
        
        Image {
            id: display
            asynchronous : true
            source: image.imagePath
            x : 3
            y : 3
            width : parent.width - 6
            height : parent.height - 6
        
            fillMode: Image.PreserveAspectCrop

            smooth: false
            mipmap : false
            sourceSize.width: parent.width /2
            sourceSize.height: parent.height/2

            onSourceChanged: {}
            onStatusChanged: {}
        }

        Rectangle {
            anchors.fill : parent
            color : "transparent"

            radius : 10
            border.width : 3
            border.color : image.palette.color.border
        }
    }

}