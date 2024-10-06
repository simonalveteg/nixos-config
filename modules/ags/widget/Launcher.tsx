import { App, Variable, Astal, Gtk, Gdk } from "astal"
import AstalApps from "gi://AstalApps"
import Hyprland from "gi://AstalHyprland"

//const winheight = (ratio) => Gdk.Screen.get_default()?.get_height()! * ratio
//const winwidth = (ratio) => Gdk.Screen.get_default()?.get_width()! * ratio


const apps = new AstalApps.Apps({
	include_entry: true,
	include_executable: true,
	include_description: true,
});

const filteredApps = Variable(apps.get_list())

function AppCard({app, child, children}: Props){
  return <button
        className="launcher-app"
        name={app.get_name()}
        tooltip_text={app.get_description()}
        onClicked={() => {
          app.launch()
          App.toggle_window("launcher")
        }}
      >
        <box vertical={false} halign={Gtk.Align.FILL} valign={Gtk.Align.FILL} spacing={5}>
          <icon icon={app.icon_name || ""} halign={Gtk.Align.CENTER} valign={Gtk.Align.CENTER} />
          <label label={app.name} halign={Gtk.Align.CENTER} valign={Gtk.Align.CENTER} lines={1} wrap={false} xalign={0} yalign={0} />
        </box>
      </button>
}

function createScrollablePage() {
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
          {filteredApps(apps => apps.map(app => (
            <AppCard app={app} />
          )))}
			</box>
		</scrollable>
	);
}

function Search(query) {
  filteredApps.set(apps.fuzzy_query(query))
}

const SearchInput = () => {
  let query = ""

  return (
    <entry
      className="launcher-search-input"
      placeholder_text="Search"
      on_changed={(entry) => {
				query = entry.get_text();
				Search(query);
			}}
			on_activate={() => {
				Search(query);
			}}
    />
  )
}

function resetState() {
  App.toggle_window("launcher");
  Search("");
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
            resetState()
          }
			  }}
			>
        <box
          vertical={true}
        >
          <SearchInput />
          <box
            vertical={true}
            hexpand={false}
            vexpand={true}
            spacing={10}
          >
            {createScrollablePage()}
          </box>
        </box>
			</eventbox>
		</window>
}


