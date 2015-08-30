package com.epitrack.guardioes.view.menu.profile;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.view.IMenu;

/**
 * @author Igor Morais
 */
public enum InterestCategory implements IMenu {

    HEALTH      (1, R.string.health),
    WELFARE     (2, R.string.welfare),
    DISEASE     (3, R.string.disease);

    private final int id;
    private final int name;

    InterestCategory(final int id, final int name) {
        this.id = id;
        this.name = name;
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
    public final int getIcon() {
        return 0;
    }

    public static InterestCategory getBy(final int id) {

        for (final InterestCategory category : InterestCategory.values()) {

            if (category.getId() == id) {
                return category;
            }
        }

        throw new IllegalArgumentException("The InterestCategory has not found.");
    }
}
