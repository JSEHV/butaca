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
import com.nokia.meego 1.0
import 'constants.js' as UIConstants
import 'moviedbwrapper.js' as TMDB

Item {
    id: galleryPreviewer
    height: 140

    property ListModel galleryPreviewerModel
    property int previewerDelegateSize: 0
    property int previewerDelegateType: TMDB.IMAGE_POSTER
    property int previewedItems: 4

    property int previewerDelegateIconWidth: 92
    property int previewerDelegateIconHeight: 138

    signal clicked()

    BorderImage {
        id: galleryPreviewerBackground
        anchors.fill: parent
        visible: galleryPreviewerMouseArea.pressed
        source: 'image://theme/meegotouch-list-fullwidth-inverted-background-pressed-vertical-center'
    }

    Flow {
        id: galleryPreviewerFlow
        anchors {
            left: parent.left
            leftMargin: UIConstants.PADDING_LARGE
            verticalCenter: parent.verticalCenter
        }
        width: parent.width - galleryPreviewerMoreIndicator.width
        height: parent.height
        spacing: UIConstants.PADDING_LARGE

        Repeater {
            id: galleryPreviewerRepeater
            model: Math.min(previewedItems, galleryPreviewerModel.count)
            delegate: Image {
                id: previewerDelegate
                width: previewerDelegateIconWidth; height: previewerDelegateIconHeight
                opacity: galleryPreviewerMouseArea.pressed ? 0.5 : 1
                fillMode: Image.PreserveAspectFit
                source: TMDB.image(previewerDelegateType,
                                   previewerDelegateSize,
                                   galleryPreviewerModel.get(index).file_path,
                                   { app_locale: appLocale} )
            }
        }
    }

    MyMoreIndicator {
        id: galleryPreviewerMoreIndicator
        anchors {
            right: parent.right
            rightMargin: UIConstants.DEFAULT_MARGIN
            verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        id: galleryPreviewerMouseArea
        anchors.fill: parent
        onClicked: galleryPreviewer.clicked()
    }
}
