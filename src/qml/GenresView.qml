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
import com.nokia.extras 1.0
import 'constants.js' as UIConstants
import 'moviedbwrapper.js' as TMDB

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

    Component { id: multipleMovieView; MultipleMoviesView {  } }

    JSONListModel {
        id: genresModel
        source: TMDB.genres_list({ app_locale: appLocale })
        query: TMDB.query_path(TMDB.GENRES_LIST)
    }

    ListView {
        id: list
        model: genresModel.model
        anchors.fill: parent
        header: Header {
            //: This appears in the browse view header
            text: qsTr('Movie genres')
        }
        delegate: MyListDelegate {
            width: parent.width
            title: model.name

            onClicked: {
                pageStack.push(multipleMovieView ,
                               {genre: id, genreName: name})
            }
        }
    }

    ScrollDecorator {
        flickableItem: list
    }

    BusyIndicator {
        id: busyIndicator
        visible: running
        running: genresModel.json === ""
        anchors.centerIn: parent
        platformStyle: BusyIndicatorStyle { size: 'large' }
    }
}
