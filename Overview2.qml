import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick.Controls

/* basic quickshell overlay that'll be a workspace overview soon
 * The first PanelWindow is the button to open it on the bottom right,
 * and the second contains the troublesome ScreencopyView
*/

ShellRoot {
	id: root
	property bool isVisible: false
	function wake() {
		isVisible=true;
	}
	function sleep() {
		isVisible=false;
	}
	
	PanelWindow{
		id: buttonWindow
		anchors {
			bottom: true
			right: true
		}
		color: buttonMouse.containsMouse?'white':'black'
		implicitWidth: button.contentWidth+10
		implicitHeight: button.height
		MouseArea {
			id: buttonMouse
			anchors.fill: parent
			hoverEnabled: true
			onClicked: {
				wake();
			}
		}
		Text {
			anchors.centerIn: parent
			id: button
			text: (Hyprland.focusedWorkspace?.id??'?')
			//font.family: "OCR A" // this isn't REQUIRED, just looks cool
			font.pixelSize: 24
			color: buttonMouse.containsMouse?'black':'white'
			horizontalAlignment: Text.AlignHCenter
		}
	}
	PanelWindow{
		visible: isVisible
		
		id: overviewRoot
		anchors {
			left: true
			right: true
			top: true
			bottom: true
		}
		WlrLayershell.layer: WlrLayer.Overlay
		color: '#80000000'
		mask: Region {}
		
		ScreencopyView {
			anchors.fill: parent
			live: true
			captureSource: Hyprland?.focusedMonitor??null // This is what requires a QtObject
		}
	}
}
