package com.epitrack.guardioes.view.menu;

import android.app.Activity;
import android.app.DialogFragment;
import android.app.Fragment;
import android.view.MenuItem;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.view.MainFragment;

public enum Menu {

    HOME        (R.id.main_menu_home, MainFragment.class),
    PROFILE     (R.id.main_menu_profile, ProfileActivity.class),
    SETTINGS    (R.id.main_menu_setting, SettingsActivity.class),
    ABOUT       (R.id.main_menu_about, AboutActivity.class),
    HELP        (R.id.main_menu_help, HelpActivity.class),
    EXIT        (R.id.main_menu_exit, AboutActivity.class);

    private final int id;
    private final Class<?> menuClass;

    Menu(final int id, final Class<?> menuClass) {

        this.id = id;
        this.menuClass = menuClass;
    }

    public final int getId() {
        return id;
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

    public static Menu getBy(final MenuItem menuItem) {

        for (final Menu menu : Menu.values()) {

            if (menu.getId() == menuItem.getItemId()) {
                return menu;
            }
        }

        throw new IllegalArgumentException("The Menu has not found.");
    }
}
