/**************************************************************************
 *    Butaca
 *    Copyright (C) 2011 Simon Pena <spena@igalia.com>
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
import com.nokia.extras 1.0

Item {
    id: genresDelegate
    width: genresDelegate.ListView.view.width; height: 80

    MultipleMoviesView { id: multipleMovieView }

    Rectangle {
        anchors.fill: content
        color: "black"; opacity: 0.3
        radius: 10
    }

    MouseArea {
        anchors.fill: parent
        onClicked: { pageStack.push(multipleMovieView , {genre: genreId}) }
    }

    Item {
        id: content
        anchors.fill: parent
        anchors.margins: 10

        Text {
            id: titleText
            font.pixelSize: 26
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10
            text: genreName
        }

        Item {
            id: viewDetails
            width: moreIndicator.width + 10
            height: parent.height
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right

            MoreIndicator {
                id: moreIndicator
                anchors.centerIn: parent
            }
        }
    }
}