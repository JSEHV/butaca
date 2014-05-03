/**************************************************************************
 *   Butaca
 *   Copyright (C) 2011 - 2012 Simon Pena <spena@igalia.com>
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 **************************************************************************/

import QtQuick 1.1
import com.nokia.meego 1.1
import com.nokia.extras 1.1
import 'constants.js' as UIConstants
import "storage.js" as Storage

Page {
    tools: ToolBarLayout {
        ToolIcon {
            iconId: 'toolbar-back'
            onClicked: {
                appWindow.pageStack.pop()
            }
        }
    }
    orientationLock: PageOrientation.LockPortrait

    Component.onCompleted: {
        Storage.initialize()
        var includeAll = Storage.getSetting('includeAll', 'true')
        var includeAdult = Storage.getSetting('includeAdult', 'true')
        var date = new Date(Storage.getSetting('showtimesDate', new Date().toString()))

        includeAllSwitch.checked = (includeAll === 'true')
        includeAdultSwitch.checked = (includeAdult === 'true')
        if (date < new Date())
            date = new Date() // now
        setDate(date)
    }

    Component.onDestruction: {
        Storage.setSetting('location', locationInput.text)
    }

    Flickable {
        id: settingsContent
        anchors {
            fill: parent
            leftMargin: UIConstants.DEFAULT_MARGIN
            rightMargin: UIConstants.DEFAULT_MARGIN
        }
        width: parent.width
        contentHeight: settingsColumnContent.height

        Column {
            id: settingsColumnContent
            width: parent.width
            spacing: UIConstants.DEFAULT_MARGIN

            Header {
                id: settingsHeader
                anchors { rightMargin: 0; leftMargin: 0 }
                //: Text shown in the settings view header
                text: qsTr('Settings')
                showDivider: false
            }

            Column {
                id: showtimesSection
                width: parent.width
                spacing: UIConstants.DEFAULT_MARGIN

                ListSectionDelegate {
                    id: showtimesSectionHeader
                    anchors { rightMargin: 0; leftMargin: 0 }
                    //: Label for the showtimes section in the settings view
                    sectionName: qsTr('Showtimes')
                }

                Row {
                    id: showtimesLocation
                    spacing: UIConstants.DEFAULT_MARGIN
                    width: parent.width

                    Label {
                        id: locationText
                        anchors.verticalCenter: locationInput.verticalCenter
                        platformStyle: LabelStyle {
                            fontPixelSize: UIConstants.FONT_DEFAULT
                        }
                        color: UIConstants.COLOR_INVERTED_FOREGROUND
                        //: Label for the default location setting to try for showtimes
                        text: qsTr('Default location')
                    }

                    TextField {
                        id: locationInput
                        //: Placeholder text for the default location. When visible, automatic location will be attempted
                        placeholderText: qsTr('Try automatically')
                        width: parent.width - locationText.width - parent.spacing
                        text: Storage.getSetting('location', '')
                        Keys.onReturnPressed: {
                            Storage.setSetting('location', text)
                        }

                        Image {
                            id: clearLocationText
                            anchors {
                                right: parent.right
                                verticalCenter: parent.verticalCenter
                            }
                            source: 'image://theme/icon-m-input-clear'
                            visible: locationInput.activeFocus
                        }

                        MouseArea {
                            id: locationInputMouseArea
                            anchors.fill: clearLocationText
                            onClicked: {
                                inputContext.reset()
                                locationInput.text = ''
                            }
                        }
                    }
                }

                Row {
                    id: showtimesDateItem
                    width: parent.width
                    spacing: UIConstants.DEFAULT_MARGIN

                    Label {
                        id: showtimesDateLabel
                        width: locationText.width
                        anchors.verticalCenter: showtimesDateButton.verticalCenter
                        platformStyle: LabelStyle {
                            fontPixelSize: UIConstants.FONT_DEFAULT
                        }
                        color: UIConstants.COLOR_INVERTED_FOREGROUND
                        //: Label for the showtimes date setting
                        text: qsTr('Date')
                    }

                    Button {
                        id: showtimesDateButton
                        width: parent.width - showtimesDateLabel.width - parent.spacing
                        onClicked: showtimesDateDialog.open()

                        Image {
                           anchors {
                               right: parent.right
                               rightMargin: UIConstants.DEFAULT_MARGIN
                               verticalCenter: parent.verticalCenter
                           }
                           height: parent.height - UIConstants.DEFAULT_MARGIN
                           source: "image://theme/meegotouch-combobox-indicator-inverted"
                       }
                    }
                }
            }

            Column {
                id: browsingSection
                width: parent.width
                spacing: UIConstants.DEFAULT_MARGIN

                ListSectionDelegate {
                    id: browsingSectionHeader
                    anchors.rightMargin: 0
                    anchors.leftMargin: 0
                    //: Label for the browsing section in the settings view
                    sectionName: qsTr('Browsing')
                }

                Item {
                    id: includeAllItem
                    width: parent.width
                    height: 60

                    Label {
                        id: includeAllText
                        anchors {
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                        }
                        platformStyle: LabelStyle {
                            fontPixelSize: UIConstants.FONT_DEFAULT
                        }
                        //: Label for the include criteria setting for adult content used when browsing
                        text: qsTr('Include content with <10 votes')
                        color: UIConstants.COLOR_INVERTED_FOREGROUND
                    }

                    Switch {
                        id: includeAllSwitch
                        anchors {
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                        }
                        onCheckedChanged: {
                            Storage.setSetting('includeAll', checked ? 'true' : 'false')
                        }
                    }
                }

                Item {
                    id: includeAdultItem
                    width: parent.width
                    height: 60

                    Label {
                        id: includeAdultText
                        anchors {
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                        }
                        platformStyle: LabelStyle {
                            fontPixelSize: UIConstants.FONT_DEFAULT
                        }
                        //: Label for the include criteria setting for adult content used when browsing
                        text: qsTr('Include adult content')
                        color: UIConstants.COLOR_INVERTED_FOREGROUND
                    }

                    Switch {
                        id: includeAdultSwitch
                        anchors {
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                        }
                        onCheckedChanged: {
                            Storage.setSetting('includeAdult', checked ? 'true' : 'false')
                        }
                    }
                }
            }
        }
    }

    DatePickerDialog {
        id: showtimesDateDialog
        titleText: "Showtimes date"
        onAccepted: {
            var date = new Date(showtimesDateDialog.year,
                                showtimesDateDialog.month - 1, // months are 0-based
                                showtimesDateDialog.day)
            if (date < new Date()) // accept future dates only
                date = new Date()
            Storage.setSetting('showtimesDate', date.toString())
            setDate(date)
        }
    }

    states: [
        State {
            name: 'showBrowsingSection'
            PropertyChanges {
                target: showtimesSection
                visible: false
            }
        },
        State {
            name: 'showShowtimesSection'
            PropertyChanges {
                target: browsingSection
                visible: false
            }
        }
    ]

    function setDate(date) {
        showtimesDateDialog.year = date.getFullYear()
        showtimesDateDialog.month = date.getMonth() + 1 // months are 0-based
        showtimesDateDialog.day = date.getDate()

        if (date.toDateString() === new Date().toDateString()) {
            //: Shown in a button when the date is set to Today.
            showtimesDateButton.text = qsTr('Today')
        } else {
            showtimesDateButton.text = Qt.formatDate(date, Qt.DefaultLocaleShortDate)
        }
    }
}
