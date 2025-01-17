Locales = {}

Locales["en"] = {
    menu_title = "Choose Your Character",
    ped_chosen = "Ped has been successfully set!",
    no_permission = "You don't have permission to use this menu!",
    unsupported_menu = "The menu is not supported for the current framework!",
    unsupported_framework = "The framework is not supported!",
    framework_not_detected = "Framework not detected, menu is unavailable!",
    installation_error = "Menu is not installed or started!",
    installation_error_n = "Notifications are not installed or started!",
}

Locales["cs"] = {
    menu_title = "Vyberte si postavu",
    ped_chosen = "Ped byl úspěšně nastaven!",
    no_permission = "Nemáte oprávnění používat toto menu!",
    unsupported_menu = "Menu není podporováno pro aktuální framework!",
    unsupported_framework = "Framework není podporován!",
    framework_not_detected = "Framework nebyl detekován, menu není dostupné!",
    installation_error = "Menu není nainstalováno nebo spuštěno!",
    installation_error_n = "Notifikáce nejsou nainstalováne nebo spuštěne!",
}

function _U(str)
    return Locales[Config.Locale][str] or str
end
