//
// No longer Maya
//



import QtQuick 2.0
import SddmComponents 2.0
import QtQuick.Effects
import QtCore
import "./components"

Rectangle { //! ROOT
  id  : maya_root

  property color primaryShade : config.primaryShade ? config.primaryShade : "#2e3ea6"
  property color primaryLight : config.primaryLight ? config.primaryLight : "#7986CB"
  property color primaryDark  : config.primaryDark  ? config.primaryDark  : "#1A237E"

  property color primaryHue1  : config.primaryHue1  ? config.primaryHue1  : "#5965B2"
  property color primaryHue2  : config.primaryHue2  ? config.primaryHue2  : "#303F9F"
  property color primaryHue3  : config.primaryHue3  ? config.primaryHue3  : "#2C3998"

  property color accentShade  : config.accentShade  ? config.accentShade  : "#FF4081"
  property color accentLight  : config.accentLight  ? config.accentLight  : "#FF80AB"

  property color accentHue1   : config.accentHue1   ? config.accentHue1   : "#FF669A"
  property color accentHue2   : config.accentHue2   ? config.accentHue2   : "#FF4081"
  property color accentHue3   : config.accentHue3   ? config.accentHue3   : "#E73677"

  property color normalText   : config.normalText   ? config.normalText   : "#ffffff"

  property color successText  : config.successText  ? config.successText  : "#43a047"
  property color failureText  : config.failureText  ? config.failureText  : "#e53935"
  property color warningText  : config.warningText  ? config.warningText  : "#ff8f00"

  property color rebootColor  : config.rebootColor  ? config.rebootColor  : "#fb8c00"
  property color powerColor   : config.powerColor   ? config.powerColor   : "#ff1744"

  readonly property color defaultBg : primaryShade ? primaryShade : "#1e88e5"

  //
  // Indicates one unit of measure (in pixels)
  //
  readonly property int spUnit: 64

  //
  // Symmetric (equal) padding on all sides
  //
  readonly property int padSym : (spUnit / 8)

  //
  // Asymmetric padding in horizontal & vertical directions
  //
  readonly property int padAsymH : (spUnit / 2)
  readonly property int padAsymV : (spUnit / 8)

  //
  // Font sizes
  //
  readonly property int spFontNormal  : 24
  readonly property int spFontSmall   : 16


  LayoutMirroring.enabled: Qt.locale().textDirection == Qt.RightToLeft
  LayoutMirroring.childrenInherit: true

  TextConstants { id: textConstants }

  Connections {
    target: sddm

    onLoginSucceeded: {
      prompt_bg.color = successText
      prompt_txt.text = textConstants.loginSucceeded

      maya_busy.visible = false;
      maya_busy_anim.stop()

      anim_success.start()
    }
    onLoginFailed: {
      prompt_bg.color = failureText
      prompt_txt.text = textConstants.loginFailed

      maya_busy.visible = false;
      maya_busy_anim.stop()

      anim_failure.start()
    }
    onInformationMessage: {
      prompt_bg.color = failureText
      prompt_txt.text = message

      maya_busy.visible = false;
      maya_busy_anim.stop()

      anim_failure.start()
    }
  }


  signal tryLogin()

  onTryLogin : {
    maya_busy.visible = true;
    maya_busy_anim.start()

    sddm.login(maya_username.text, maya_password.text, maya_root.sessionIndex);
  }


    FontLoader {
        id: opensans_cond_light
        source: "fonts/OpenSans_CondLight.ttf"
    }
    FontLoader {
        id: playpen_sans
        source : "fonts/PlaypenSans-VariableFont_wght.ttf"
    }
    //
    //Wallpapelera

    Repeater {
        model: screenModel

        Item {
            Image {
                id: wallpaper

                x: geometry.x
                y: geometry.y
                width: geometry.width
                height: geometry.height

                source: "file:///var/lib/sddm/wallpaper/current.png"
                fillMode: Image.PreserveAspectCrop
            }
                //
                // blur effect
                //
                ShaderEffectSource {
                    id: blurredSource

                    sourceItem: wallpaper

                    sourceRect: Qt.rect(
                        sidePanel.x,
                        sidePanel.y,
                        sidePanel.width,
                        sidePanel.height
                    )

                    width: sidePanel.width
                    height: sidePanel.height

                    hideSource: false
                }

                MultiEffect {
                    source: blurredSource

                    x: sidePanel.x
                    y: sidePanel.y
                    width: sidePanel.width
                    height: sidePanel.height

                    autoPaddingEnabled: false

                    blurEnabled: true
                    blur: 1
                    blurMax: 32
                }


        }
    }

  //
  // Status bar on top
  // Ya lo volvi a poner pero ahora solo da la bateria


 //
  // Header
  // Este tampoco era aeroestetico

  //
  // Toolbar, ya no pero antes si
  // AHORA es el rectangulo que hace el blur

      // Layout selection
      // No me hizo falta y lo quité, no era estetico

      //
      // Session esta mas abajo
      //
//
// Footer
//
Item {
    id: footer

    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom

    height: 72

    //
    // Session selector
    //
   
    //
    // Action buttons
    //
    Row {
        anchors.right: parent.right
        anchors.rightMargin: 24
        anchors.verticalCenter: parent.verticalCenter

        spacing: 12

        //
        // Reboot
        //
        Text {
            text: "󰜉"   // reboot
            color: "#AAFFFFFF"
            font.family: "Symbols Nerd Font"
            font.pixelSize: 28

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onEntered: parent.color = "#FFFFFFFF"
                onExited: parent.color = "#AAFFFFFF"
                onClicked: sddm.reboot()
            }
        }

        Text {
            text: "󰐥"
            color: "#FFF00000"
            font.family: "Symbols Nerd Font"
            font.pixelSize: 28

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onEntered: parent.color = "#FFFF4444"
                onExited: parent.color = "#FFF00000"
                onClicked: sddm.powerOff()
            }
        }
    }
}



  //
  // Lo pusé yo ya que queria una parte con blur a la izquierda to do aeroestetico
  //

  Rectangle { // side panel
    id: sidePanel

    x: 0
    y: 0
    width: 700
    height: parent.height

    color: "#22000000"

    property bool loginActive: false
    
    focus: true

    Keys.onPressed: {
        if (event.key === Qt.Key_Escape) {
            loginActive = false
            maya_username.focus = false
            maya_password.focus = false

            event.accepted = true
            sidePanel.forceActiveFocus()
            return
        }

        if (!loginActive) {
            loginActive = true
            maya_password.focus = true
            event.accepted = true
        }
    }
    //
    // Login container
    //
    Rectangle { // login panel
        id : loginPanel
        anchors.centerIn : parent
        y : 50
        width   : 380
        height  : 420

        radius: 24

        color   : "transparent"
        opacity: sidePanel.loginActive ? 1 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: 400
                easing.type: Easing.InOutCubic
            }
        }
        //
        // USERNAME
        Rectangle { // username
            x: padSym
            y: spUnit + padSym

            width: parent.width - (padSym * 2)
            height: spUnit - (padSym * 2)

            radius: height / 2

            color: "#18FFFFFF"
            border.width: 4
            border.color: "#CAFFFFFF"

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 18
                anchors.verticalCenter: parent.verticalCenter

                text: ""

                color: "#CCFFFFFF"
                font.pixelSize: 22
            }

            TextBox {
                id: maya_username

                text: userModel.lastUser

                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 55
                anchors.rightMargin: 15
                anchors.verticalCenter: parent.verticalCenter

                height: parent.height

                color: "transparent"
                borderColor: "transparent"
                focusColor: "transparent"
                hoverColor: "transparent"
                textColor: "#FFFFFF"

                font.family: playpen_sans.name
                font.pixelSize: 20

                KeyNavigation.tab: maya_password

                Keys.onPressed: {
                    if (event.key === Qt.Key_Return ||
                        event.key === Qt.Key_Enter) {
                        if (!loginActive) {
                            loginActive = true
                            maya_password.focus = true
                        }
                        else
                        {
                        maya_password.focus = true
                        event.accepted = true
                        }
                    }
                    if (event.key === Qt.Key_Escape) {
                        sidePanel.loginActive = false
                        maya_username.focus = false
                        event.accepted = true
                        sidePanel.forceActiveFocus()
                        return
                    }
                }
            }
        }
        //
        // PASSWORD
        Rectangle { // password
            x: padSym
            y: (2.3 * spUnit) + padSym

            width: parent.width - (padSym * 2)
            height: spUnit - (padSym * 2)

            radius: height / 2

            color: "#18FFFFFF"
            border.width: 4
            border.color: "#CAFFFFFF"

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 18
                anchors.verticalCenter: parent.verticalCenter

                text: "󰟵"

                color: "#CCFFFFFF"
                font.pixelSize: 22
            }

            PasswordBox {
                id: maya_password

                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 55
                anchors.rightMargin: 15
                anchors.verticalCenter: parent.verticalCenter

                height: parent.height

                color: "transparent"
                borderColor: "transparent"
                focusColor: "transparent"
                hoverColor: "transparent"
                textColor: "#FFFFFF"

                font.family: opensans_cond_light.name
                font.pixelSize: spFontSmall

                image: ""

                tooltipEnabled: true
                tooltipText: textConstants.capslockWarning
                tooltipFG: "#FFFFFF"
                tooltipBG: "#14141e"

                KeyNavigation.backtab: maya_username

                Keys.onPressed: {
                    if (event.key === Qt.Key_Return ||
                        event.key === Qt.Key_Enter) {

                        maya_root.tryLogin()
                        event.accepted = true
                    }
                    if (event.key === Qt.Key_Escape) {
                        sidePanel.loginActive = false
                        maya_password.focus = false
                        event.accepted = true
                        sidePanel.forceActiveFocus()
                        return
                    }
                }
            }

                Text {
                    anchors.right: parent.right
                    anchors.rightMargin: 18
                    anchors.verticalCenter: parent.verticalCenter

                    text: "󰁔"

                    color: "#AAFFFFFF"
                    font.pixelSize: 24
            }
        }

        Text {
            x: padSym
            y: (3.8 * spUnit) + padSym
            anchors.right: parent.right
            anchors.rightMargin: 18
            anchors.verticalCenter: parent.verticalCenter

            text: "hyprland"

            color: "#AAA6A6A6"
            font.pixelSize: 12
        }
    }
    //
    // Clock panel
    //
    SpClock {
        id: clockPanel

        anchors.centerIn: parent
        y: -40

        width: 380
        height: 140

        tColor: "#FFFFFFFF"

        opacity: sidePanel.loginActive ? 0 : 1

        Behavior on opacity {
            NumberAnimation {
                duration: 400
                easing.type: Easing.InOutCubic
            }
        }
    }

}
   //
  // Busy animation (just above footer)
  //
 Rectangle {
    id: maya_busy

    x: (parent.width - (8 * spUnit)) / 2
    y: parent.height - (1.5 * spUnit)

    width: 8 * spUnit
    height: spUnit

    visible: false
    color: "transparent"

    property real wavePhase: 0

    Row {
        anchors.centerIn: parent
        spacing: spUnit * 0.10

        Repeater {
            model: 20

            Rectangle {
                width: spUnit * 0.10

                anchors.verticalCenter: parent.verticalCenter
                radius : spUnit * 0.05
                color: "#CAFFFFFF"

                property real noise: [
                    0.00, -0.12, 0.08, -0.06, 0.15,
                    -0.10, 0.05, -0.14, 0.09, -0.04
                ][index]

                height: {
                    var position = index / 9

                    // Moving pulse
                    var pulse = Math.exp(
                        -Math.pow(
                            Math.sin(
                                (position * Math.PI) -
                                maya_busy.wavePhase
                            ),
                            2
                        ) * 4
                    )

                    // Small irregularity for each bar
                    pulse += noise

                    return spUnit * (
                        0.20 +
                        Math.max(0, pulse) * 0.65
                    )
                }
            }
        }
    }

    NumberAnimation {
        id: maya_busy_anim

        target: maya_busy
        property: "wavePhase"

        from: 0
        to: Math.PI * 2

        duration: 1800
        loops: Animation.Infinite

        running: maya_busy.visible
    }
}
  //
  // Prompt container
  //
  Rectangle {
    id      : prompt_bg

    x       : (parent.width / 4)
    y       : (parent.height - (3 * spUnit))
    width   : (parent.width / 2)
    height  : spUnit

    color   : "transparent"

    /*Text {
      id      : prompt_txt

      x       : padSym
      y       : padSym
      width   : (parent.width  - (padSym * 2))
      height  : (parent.height - (padSym * 2))

      color   : normalText

      text    : textConstants.prompt

      font.pixelSize  : spFontNormal

      horizontalAlignment : Text.AlignHCenter
      verticalAlignment   : Text.AlignVCenter
  }*/

    SequentialAnimation on color {
      id      : anim_success
      running : false

      ColorAnimation {
        from: "transparent"
        to: successText
        duration: 250
      }
    }

    SequentialAnimation on color {
      id      : anim_failure
      running : false

      ColorAnimation {
        from: "transparent"
        to: failureText
        duration: 250
      }

      PauseAnimation {
        duration: 500
      }

      ColorAnimation {
        from: failureText
        to: "transparent"
        duration: 500
      }

      onStopped: {
        maya_password.text  = ""
        prompt_txt.text     = textConstants.prompt
      }
    }
  }


  Component.onCompleted: {
    if (maya_username.text === "")
      maya_username.focus = true
    else
      maya_password.focus = true
  }
}
