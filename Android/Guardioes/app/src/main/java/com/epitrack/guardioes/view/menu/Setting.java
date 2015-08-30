package com.epitrack.guardioes.view.menu;

import com.epitrack.guardioes.R;

/**
 * @author Igor Morais
 */
public enum Setting {

    ALERT (R.string.alert),
    SOUND (R.string.sound),
    EMAIL (R.string.mails);

    private final int name;

    Setting(final int name) {
        this.name = name;
    }

    public int getName() {
        return name;
    }
}
