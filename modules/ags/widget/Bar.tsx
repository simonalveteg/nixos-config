import { App, Variable, Astal, Gtk, bind } from "astal"
import Battery from "gi://AstalBattery"

const battery = Battery.get_default()
const time = Variable<string>("").poll(1000, "date")
const batteryText = (p) => `${Math.floor(p*100)}%`

export default function Bar(monitor: number) {
    return <window
        className="Bar"
        name={"Bar"}
        monitor={monitor}
        exclusivity={Astal.Exclusivity.EXCLUSIVE}
        anchor={Astal.WindowAnchor.TOP
            | Astal.WindowAnchor.LEFT
            | Astal.WindowAnchor.RIGHT}
        application={App}>
        <centerbox>
            <button
                onClicked="echo hello"
                halign={Gtk.Align.CENTER} >
                <label label={bind(battery, "percentage").as(p => batteryText(p))} />
            </button>
            <box />
            <button
                onClick={() => print("hello")}
                halign={Gtk.Align.CENTER} >
                <label label={time()} />
            </button>
        </centerbox>
    </window>
}

