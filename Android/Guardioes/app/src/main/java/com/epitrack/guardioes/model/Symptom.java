package com.epitrack.guardioes.model;

/**
 * Created by IgorMorais on 6/12/15.
 */
public enum Symptom {

    // TODO: Stub only
    FEVER ("Febre 1"),
    FEVER1 ("Febre 2"),
    FEVER2 ("Febre 3"),
    FEVER3 ("Febre 4"),
    FEVER4 ("Febre 5"),
    FEVER5 ("Febre 6"),
    FEVER6 ("Febre 7"),
    FEVER7 ("Febre 8"),
    FEVER8 ("Febre 9"),
    FEVER9 ("Febre 10"),
    FEVER10 ("Febre 11");

    private final String name;

    Symptom(final String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }
}
