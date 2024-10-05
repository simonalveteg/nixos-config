import { App } from "astal"
import style from "inline:./style.css"
import Bar from "./widget/Bar"
import Launcher from "./widget/Launcher"

App.start({
    css: style,
    main() {
        Bar(0)
        Launcher(0)
    },
})
