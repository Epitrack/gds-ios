package com.epitrack.guardioes.view;

import com.epitrack.guardioes.R;

/**
 * @author Igor Morais
 */
public enum Phone implements IMenu {

    EMERGENCY       (1, R.string.emergency, ""),
    POLICE          (2, R.string.police, ""),
    FIREMAN         (3, R.string.fireman, ""),
    DEFENSE         (4, R.string.defense, "");

    private final int id;
    private final int name;
    private final String number;

    Phone(final int id, final int name, final String number) {
        this.id = id;
        this.name = name;
        this.number = number;
    }

    @Override
    public final int getId() {
        return id;
    }

    @Override
    public final int getName() {
        return name;
    }

    @Override
    public int getIcon() {
        return 0;
    }

    public final String getNumber() {
        return number;
    }

    public static Phone getBy(final long id) {

        for (final Phone phone : Phone.values()) {

            if (phone.getId() == id) {
                return phone;
            }
        }

        throw new IllegalArgumentException("The Phone has not found.");
    }
}
