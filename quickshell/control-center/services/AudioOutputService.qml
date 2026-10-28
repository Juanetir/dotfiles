import QtQml
import Quickshell
import Quickshell.Services.Pipewire

QtObject {
    id: root

    property var outputs: []
    property var currentOutput: Pipewire.defaultAudioSink

    property Connections pipewireConnection: Connections {
        target: Pipewire

        function onReadyChanged() {
            if (Pipewire.ready)
                root.refresh()
        }
    }

    function refresh() {
        var result = []

        for (var i = 0; i < Pipewire.nodes.values.length; i++) {
            var node = Pipewire.nodes.values[i]

            if (node.isSink && !node.isStream)
                result.push(node)
        }

        root.outputs = result

        console.log("=== Audio outputs:", root.outputs.length, "===")

        for (var i = 0; i < root.outputs.length; i++) {
            console.log(
                i,
                root.outputs[i].name,
                root.outputs[i].description,
                root.outputs[i].nickname
            )
        }
    }

    function setOutput(node) {
        if (!node)
            return

        Pipewire.preferredDefaultAudioSink = node
    }

    Component.onCompleted: {
        if (Pipewire.ready)
            refresh()
    }
}