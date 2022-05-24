use crate::app::plugin_matchers::PluginMode;
use once_cell::sync::Lazy;
use pop_launcher_toolkit::plugins::web::Config as WebConfig;

pub(crate) static WEB_CONFIG: Lazy<WebConfig> = Lazy::new(pop_launcher_toolkit::plugins::web::load);

#[derive(Debug, PartialEq, Clone)]
pub enum ActiveMode {
    History,
    DesktopEntry,
    Web(String),
    Plugin {
        plugin_name: String,
        modifier: String,
        history: bool,
    },
}

impl From<PluginMode> for ActiveMode {
    fn from(plugin_mode: PluginMode) -> Self {
        let mode = plugin_mode.plugin_name.as_str();
        match mode {
            "web" => ActiveMode::Web(plugin_mode.modifier),
            _other => ActiveMode::Plugin {
                plugin_name: plugin_mode.plugin_name,
                modifier: plugin_mode.modifier,
                history: plugin_mode.history,
            },
        }
    }
}

impl Default for ActiveMode {
    fn default() -> Self {
        ActiveMode::History
    }
}
