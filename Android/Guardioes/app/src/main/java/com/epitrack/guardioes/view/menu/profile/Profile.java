package com.epitrack.guardioes.view.menu.profile;

import com.epitrack.guardioes.R;

/**
 * @author Igor Morais
 */
public enum Profile {

    PROFILE     (1, R.string.edit_profile, R.string.message_profile),
    INTEREST    (2, R.string.interest, R.string.message_interest);

    private final int id;
    private final int name;
    private final int message;

    Profile(final int id, final int name, final int message) {
        this.id = id;
        this.name = name;
        this.message = message;
    }

    public final int getId() {
        return id;
    }

    public final int getName() {
        return name;
    }

    public final int getMessage() {
        return message;
    }

    public static Profile getBy(final int id) {

        for (final Profile profile : Profile.values()) {

            if (profile.getId() == id) {
                return profile;
            }
        }

        throw new IllegalArgumentException("The Profile has not found.");
    }
}
