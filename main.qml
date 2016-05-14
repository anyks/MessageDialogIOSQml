import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Controls 1.4

Window {
	visible: true


	MessageBoxAnyksiOS {
		id:		msgBoxAnyks
		title:	"Example Dialog"
		text:	"It is an example dialog. Press any button to quit."

		onButtonClick: {
			console.log("++++++", index, name);
		}
	}

	MainForm {
		anchors.fill: parent

		mouseArea.onClicked: {

			msgBoxAnyks.buttons.clear();

			msgBoxAnyks.buttons.append({"text": "Cancel"});

			msgBoxAnyks.buttons.append({
				"text":		"Ok",
				"default":	true
			});

			msgBoxAnyks.open();

		}
	}
}
