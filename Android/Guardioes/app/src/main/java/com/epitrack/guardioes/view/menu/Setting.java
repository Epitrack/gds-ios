package com.epitrack.guardioes.view.menu;

import com.epitrack.guardioes.R;

public enum Setting {

    ALERT (R.string.setting_alert),
    SOUND (R.string.setting_sound),
    EMAIL (R.string.setting_mail);

    private final int name;

    Setting(final int name) {
        this.name = name;
    }

    public int getName() {
        return name;
    }
}
