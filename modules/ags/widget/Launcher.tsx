import { App, Variable, Astal, Gtk, Gdk } from "astal"
import AstalApps from "gi://AstalApps"
import Hyprland from "gi://AstalHyprland"

const winheight = (ratio) => Gdk.Screen.get_default()?.get_height()! * ratio
const winwidth = (ratio) => Gdk.Screen.get_default()?.get_width()! * ratio


const Apps = new AstalApps.Apps({
	include_entry: true,
	include_executable: true,
	include_description: true,
});

const Applications = Apps.get_list();

const sortedApplications = Applications.sort((a, b) => {
	return a.get_name().localeCompare(b.get_name());
});

function createAppList(appList) {
  return appList.sort((a, b) => {
		return a.get_name().localeCompare(b.get_name());
	}).map(app => (
      <button
        className="launcher-app"
        name={app.get_name()}
        tooltip_text={app.get_description()}
        onClicked={() => {
          app.launch()
          App.toggle_window("launcher")
        }}
      >
        <box vertical={false} halign={Gtk.Align.FILL} valign={Gtk.Align.FILL} spacing={5}>
          <icon icon={app.icon_name} halign={Gtk.Align.CENTER} valign={Gtk.Align.CENTER} />
          <label label={app.name} halign={Gtk.Align.CENTER} valign={Gtk.Align.CENTER} lines={1} wrap={false} xalign={0} yalign={0} />
        </box>
      </button>
  ))
}

function createScrollablePage(appList) {
	return (
		<scrollable
			className="launcher-apps"
			vscroll={Gtk.PolicyType.AUTOMATIC}
			hscroll={Gtk.PolicyType.NEVER}
			vexpand={true}
			hexpand={true}
			halign={Gtk.Align.FILL}
			valign={Gtk.Align.FILL}
		>
			<box halign={Gtk.Align.FILL} valign={Gtk.Align.FILL} hexpand={false} vexpand={true} vertical={true}>
				{createAppList(appList)}
			</box>
		</scrollable>
	);
}


export default function Launcher(monitor: number) {
    return <window
			name={"launcher"}
			className={"Launcher"}
			anchor={Astal.WindowAnchor.TOP | Astal.WindowAnchor.BOTTOM | Astal.WindowAnchor.LEFT}
			layer={Astal.Layer.OVERLAY}
			exclusivity={Astal.Exclusivity.NORMAL}
			keymode={Astal.Keymode.EXCLUSIVE}
			visible={false}
			application={App}
			clickThrough={false}
		>
			<eventbox 
        className={"launcher-container"}
        hexpand={false}
        vexpand={false}
        halign={Gtk.Align.FILL}
        valign={Gtk.Align.FILL}
        onKeyPressEvent={(_, event) => {
          if (event.get_keyval()[1] === Gdk.KEY_Escape) {
            App.toggle_window("launcher");
          }
			  }}
			>
        <box
          vertical={true}
          hexpand={false}
          vexpand={true}
          spacing={10}
        >
        { createScrollablePage(sortedApplications) }
        </box>
			</eventbox>
		</window>
}


