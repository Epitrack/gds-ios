package com.epitrack.guardioes.view.menu;

import android.app.Activity;
import android.app.DialogFragment;
import android.app.Fragment;

import com.epitrack.guardioes.R;

public enum Menu {

    PROFILE     (1, R.string.profile, R.drawable.ic_launcher, ProfileActivity.class),
    SETTINGS    (2, R.string.settings, R.drawable.ic_launcher, SettingsActivity.class),
    ABOUT       (3, R.string.about, R.drawable.ic_launcher, AboutActivity.class),
    HELP        (4, R.string.help, R.drawable.ic_launcher, HelpActivity.class),
    EXIT        (5, R.string.exit, R.drawable.ic_launcher, AboutActivity.class);

    private final int id;
    private final int name;
    private final int icon;
    private final Class<?> menuClass;

    Menu(final int id, final int name, final int icon, final Class<?> menuClass) {

        this.id = id;
        this.name = name;
        this.icon = icon;
        this.menuClass = menuClass;
    }

    public final int getId() {
        return id;
    }

    public final int getName() {
        return name;
    }

    public final int getIcon() {
        return icon;
    }

    public final Class<?> getMenuClass() {
        return menuClass;
    }

    public final String getTag() {
        return menuClass.getSimpleName();
    }

    public final boolean isDialog() {
        return DialogFragment.class.isAssignableFrom(menuClass);
    }

    public final boolean isFragment() {
        return Fragment.class.isAssignableFrom(menuClass);
    }

    public final boolean isActivity() {
        return Activity.class.isAssignableFrom(menuClass);
    }

    public static Menu getBy(final int id) {

        for (final Menu menu : Menu.values()) {

            if (menu.getId() == id) {
                return menu;
            }
        }

        throw new IllegalArgumentException("The Menu has not found.");
    }

    public static Menu getBy(final String name) {

        for (final Menu menu : Menu.values()) {

            if (menu.name().equals(name)) {
                return menu;
            }
        }

        throw new IllegalArgumentException("The Menu has not found.");
    }
}