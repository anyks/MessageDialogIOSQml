import QtQuick 2.6
import QtQuick.Controls 1.4

// MessageBox iOS
Rectangle {
	// Основные переменные
	property variant main
	property alias title:	titleMsg.text
	property alias text:	textMsg.text

	// Сигналы
	signal buttonClick (int index, string name)

	// Метод отображения блока
	function open(object){
		visible = true;
		// Если объект блока для блокировки передан
		if(object){
			// Запоминаем блок для блокировки
			main = object;
			// Блокируем указанный блок
			main.enabled = false;
		}
	}

	// Метод скрытия блока
	function close(object){
		visible = false;
		// Если объект блока для блокировки передан
		if(object) object.enabled = true;
		// Разблокируем ранее запомненный блок
		else if(main) main.enabled = true;
	}

	// Метод добавления кнопок
	function addButtons(arr){
		// Переходим по всему массиву
		if(Array.isArray(arr)){
			// Очищаем предыдущие кнопки
			dataModel.clear();
			// Переходим по всему массиву и добавляем кнопки
			for(var i = 0; i < arr.length; i++) dataModel.append(arr[i]);
		}
	}

	// Параметры блока
	id:				msgbox
	anchors.fill:	parent
	visible:		false
	color:			"transparent"
	z:				1000

	// Задний фон
	Rectangle {
		anchors.fill:	parent
		color:			"black"
		opacity:		0.4
		z:				1
	}

	// Всплывающий блок
	Rectangle {
		// Текущий размер блока
		property real defH: (titleMsg.contentHeight + textMsg.contentHeight) * 2
		// Параметры блока
		id:						msg
		x:						((parent.width / 2) - (this.width / 2))
		y:						((parent.height / 2) - (this.height / 2))
		clip:					true
		radius:					8
		opacity:				0.8
		width:					250
		implicitHeight:			(defH < 135 ? 135 : defH)
		anchors.leftMargin:		63
		anchors.rightMargin:	anchors.leftMargin
		color:					"white"
		z:						2

		// Если размер блока изменился
		onHeightChanged: {
			// Если размер блока существует
			if(msgbox.height){
				// Получаем размер половины экрана
				var rateHScreen = (msgbox.height / 2);
				// Если высота текущего окна выше половины высоты экрана тогда фиксируем высоту
				if(implicitHeight > rateHScreen){
					// Фиксируем высоту блока
					implicitHeight = rateHScreen;
					// Устанавливаем минимальное значение шрифта
					textMsg.minimumPointSize = 5;
				}
			}
		}

		// Текстовые блоки
		Rectangle {
			id:						texts
			anchors.fill:			parent
			anchors.margins:		(parent.width / 15)
			anchors.bottomMargin:	buttons.height
			color:					"transparent"

			// Заголовок
			Label {
				id:						titleMsg
				width:					parent.width
				minimumPointSize:		10
				font.pointSize:			16
				font.bold:				true
				font.family:			"Tahoma"
				fontSizeMode:			Text.Fit;
				horizontalAlignment:	Text.AlignHCenter
				wrapMode:				Text.WordWrap
				clip:					true
				color:					"black"
				text:					qsTr("Title")
			}

			// Текст
			Label {
				id:						textMsg
				anchors.fill:			parent
				anchors.topMargin:		(titleMsg.contentHeight + (titleMsg.contentHeight * 30 / 100))
				width:					parent.width
				font.pointSize:			13
				font.family:			"Tahoma"
				fontSizeMode:			Text.Fit;
				horizontalAlignment:	Text.AlignHCenter
				wrapMode:				Text.WordWrap
				clip:					true
				color:					"black"
				text:					qsTr("Text")
			}
		}

		// Блок с кнопками
		Rectangle {
			id:					buttons
			y:					(texts.height + texts.anchors.topMargin)
			width:				parent.width
			height:				45
			anchors.margins:	0
			color:				"transparent"

			// Верхний бордюр
			Rectangle {
				x:			0
				y:			0
				width:		parent.width
				height:		2
				color:		"#d9d9d9"
				visible:	(dataModel.count > 1)
			}

			// Список кнопок
			ListView {
				id:				list
				width:			parent.width
				height:			parent.height
				model:			dataModel
				clip:			true

				// Делегат
				delegate: Item {
					// Кнопка
					Rectangle {
						x:		(model.index ? this.width * model.index : 0)
						width:	(buttons.width / dataModel.count)
						height:	buttons.height
						color:	"transparent"

						// Разделительная линия
						Rectangle {
							x:			parent.width - this.width
							y:			0
							width:		2
							height:		parent.height
							color:		"#d9d9d9"
							visible:	(model.index < (dataModel.count - 1))
						}

						// Лейблы
						Label {
							anchors.fill:			parent
							anchors.margins:		5
							minimumPointSize:		5
							font.pointSize:			16
							font.bold:				(model["default"] || (dataModel.count === 1) ? true : false)
							font.family:			"Tahoma"
							fontSizeMode:			Text.Fit;
							horizontalAlignment:	Text.AlignHCenter
							verticalAlignment:		Text.AlignVCenter
							wrapMode:				Text.WordWrap
							clip:					true
							color:					"#0381ef"
							text:					model.text
						}

						// Обработчик событий
						MouseArea {
							id:				area
							anchors.fill:	parent
							// Устанавливаем событие щелчка по выбранной кнопке
							onClicked: {
								// Скрываем блок
								msgbox.visible = false;
								// Разблокируем ранее запомненный блок
								if(main) main.enabled = true;
								// Отправляем сигнал щелчка
								msgbox.buttonClick(model.index, model.text);
							}
						}
					}
				}
			}

			// Список данных кнопок
			ListModel { id: dataModel }
		}
	}
}
