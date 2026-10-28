
import QtQuick 2.15
import "./components"

QtObject {
    id: theme

    // ── Typography ──────────────────────────────

    
    // ── Typography ──────────────────────────────

    
    // ── Typography ──────────────────────────────

    property FontLoader playpenSans: FontLoader {
        source: Qt.resolvedUrl("assets/PlaypenSans-VariableFont_wght.ttf")
    }
    property FontLoader iconFont: FontLoader {
        source: "/usr/share/fonts/TTF/JetBrainsMonoNerdFont-Regular.ttf"
    }

    readonly property string fontFamily: playpenSans.name
    readonly property bool fontLoaded: playpenSans.status === FontLoader.Ready

    readonly property int fontRegular: 400
    readonly property int fontMedium: 500
    readonly property int fontSemiBold: 600
    readonly property int fontBold: 700


    // ── Colors ──────────────────────────────────

    readonly property color background: "#151720"
    readonly property color surface: "#222534"
    readonly property color surfaceElevated: "#292D40"

    readonly property color accent: "#AEB7EF"
    readonly property color accentHover: "#C3CAFF"

    readonly property color border: "#555B7A"
    readonly property color borderSubtle: "#393E55"

    readonly property color text: "#EFF0FA"
    readonly property color textMuted: "#A2A7C2"
    readonly property color placeholder: "#777D9C"

    // ── Transparency ────────────────────────────

    readonly property real cardOpacity: 0.92
    readonly property real inputOpacity: 0.65

    // ── Shape ───────────────────────────────────

    readonly property int radiusSmall: 8
    readonly property int radiusMedium: 14
    readonly property int radiusLarge: 22
    readonly property int radiusPill: 999

    // ── Spacing ─────────────────────────────────

    readonly property int spacingXS: 4
    readonly property int spacingS: 8
    readonly property int spacingM: 16
    readonly property int spacingL: 24
    readonly property int spacingXL: 32

    // ── Login card ──────────────────────────────

    readonly property int loginCardWidth: 360
    readonly property int avatarSize: 88
    readonly property int inputHeight: 48
}
