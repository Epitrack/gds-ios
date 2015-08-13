package com.epitrack.guardioes.view.welcome;

import com.epitrack.guardioes.R;

public enum Welcome {

    WELCOME     (1, R.layout.welcome_page),
    SYMPTOM     (2, R.layout.symptom_page),
    MAP         (3, R.layout.map_page),
    TIP         (4, R.layout.tip_page);

    private final int id;
    private final int layout;

    Welcome(final int id, final int layout) {
        this.id = id;
        this.layout = layout;
    }

    public final int getId() {
        return id;
    }

    public final int getLayout() {
        return layout;
    }

    public static Welcome getBy(final int id) {

        for (final Welcome welcome : Welcome.values()) {

            if (welcome.getId() == id) {
                return welcome;
            }
        }

        throw new IllegalArgumentException("The Welcome has not found.");
    }
}
