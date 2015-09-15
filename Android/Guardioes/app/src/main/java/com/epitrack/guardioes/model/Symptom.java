package com.epitrack.guardioes.model;

/**
 * Created by IgorMorais on 6/12/15.
 */
public enum Symptom {

    FEVER ("Febre"),
    FEVER1 ("Tosse"),
    FEVER2 ("Náusea ou vômito"),
    FEVER3 ("Manchas vermelhas no corpo"),
    FEVER4 ("Dor nas juntas"),
    FEVER5 ("Diarreia"),
    FEVER6 ("Dor do corpo"),
    FEVER7 ("Sangramento"),
    FEVER8 ("Dor de cabeça"),
    FEVER9 ("Olhos vermelhos"),
    FEVER10 ("Coceira"),
    FEVER11 ("Tive contato com alguém com um desses sintomas"),
    FEVER12 ("Procurei um serviço de saúde"),
    FEVER13 ("Estive fora do Brasil nos últimos 14 dias");

    private final String name;

    Symptom(final String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }
}
