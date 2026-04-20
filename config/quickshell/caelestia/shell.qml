//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma Env QSG_RENDER_LOOP=threaded
//@ pragma Env QT_QUICK_FLICKABLE_WHEEL_DECELERATION=10000

import "modules"
import "modules/drawers"
import "modules/background"
import "modules/areapicker"
import "modules/lock"
import "modules/anime"
import "modules/manga"
import Quickshell
import Quickshell.Io
import QtQuick

ShellRoot {
    settings.watchFiles: true

    Background {}
    Drawers {}
    AreaPicker {}
    Lock {
        id: lock
    }

    ConfigToasts {}
    Shortcuts {}
    BatteryMonitor {}
    IdleMonitors {
        lock: lock
    }

    PanelWindow {
        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }
        color: transparent
        focusable: true
        Loader {
            active: false
            id: animeLoader
            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
            }
            sourceComponent: AnimePanel{
                id: animePlayer
            }
        }
        mask: Region {
            Region{
                item: animeLoader.item.visible ? animeLoader.item : null
            }
        }
        Timer {
            id: closeAnimeTimer
            interval: 600
            onTriggered: animeLoader.active = false
        }

        Connections {
            target: animeLoader.item
            function onVisibleChanged() {
                if (animeLoader.item && !animeLoader.item.visible) {
                    closeAnimeTimer.start()
                }
            }
        }
        IpcHandler {
            target: "animePlayer"

            function toggle(): void {
                if (!animeLoader.active) {
                    animeLoader.active = true
                    animeLoader.item.visible = true
                } else {
                    animeLoader.item.visible = !animeLoader.item.visible
                }
            }
        }
    }

}

