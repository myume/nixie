import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: root
    property list<var> desktopEntries: []
    property bool retry: true

    function query(searchString: string) {
        fselQuery.exec(["fsel", "--stdout", "--filter-actions", "-ss", searchString]);
    }

    function launch(app: var) {
        retry = true;
        fselLaunch.exec(["fsel", "-r", "-d", "-p", app.name]);
    }

    Process {
        id: fselClearCache
        command: ["fsel", "-r", "--clear-cache"]
        onExited: fselLaunch.running = true
        onRunningChanged: {
            if (running)
                console.info("Clearing fsel cache...");
        }
    }

    Process {
        id: fselLaunch
        workingDirectory: Quickshell.env("HOME")
        stderr: StdioCollector {
            onStreamFinished: {
                if (text !== "")
                    console.warn(text);

                if (text.includes("No such file or directory") && root.retry) {
                    root.retry = false;
                    fselClearCache.running = true;
                }
            }
        }
        onExited: fselInit.running = true
    }

    Process {
        id: fselInit
        running: true
        command: ["fsel", "--stdout", "--filter-actions"]
        stdout: StdioCollector {
            onStreamFinished: {
                if (text !== "")
                    root.desktopEntries = JSON.parse(text);
            }
        }
    }

    Process {
        id: fselQuery
        stdout: StdioCollector {
            onStreamFinished: {
                if (text !== "")
                    root.desktopEntries = JSON.parse(text);
            }
        }
    }
}
