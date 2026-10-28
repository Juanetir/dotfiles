
import QtQuick 2.15

Image {
    id: avatar

    source: "avatar.png"
    fillMode: Image.PreserveAspectCrop
    smooth: true
    mipmap: true

    // El tamaño lo controla el componente que lo carga.
    sourceSize.width: 256
    sourceSize.height: 256
}
