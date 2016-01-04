package com.epitrack.guardioes.view.menu;

import android.app.Activity;
import android.app.DialogFragment;
import android.app.Fragment;
import android.view.MenuItem;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.view.HomeFragment;
import com.epitrack.guardioes.view.menu.help.HelpFragment;
import com.epitrack.guardioes.view.menu.profile.ProfileActivity;
import com.epitrack.guardioes.view.menu.profile.ProfileFragment;

/**
 * @author Igor Morais
 */
public enum HomeMenu {

    HOME        (R.id.home, HomeFragment.class),
    PROFILE     (R.id.profile, ProfileActivity.class),
    //SETTINGS    (R.id.setting, SettingFragment.class),
    ABOUT       (R.id.about, AboutFragment.class),
    HELP        (R.id.help, HelpFragment.class),
    EXIT        (R.id.exit, null);

    private final int id;
    private final Class<?> menuClass;

    HomeMenu(final int id, final Class<?> menuClass) {
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

    public static HomeMenu getBy(final int id) {

        for (final HomeMenu menu : HomeMenu.values()) {

            if (menu.getId() == id) {
                return menu;
            }
        }

        throw new IllegalArgumentException("The HomeMenu has not found.");
    }

    public static HomeMenu getBy(final MenuItem menuItem) {

        for (final HomeMenu menu : HomeMenu.values()) {

            if (menu.getId() == menuItem.getItemId()) {
                return menu;
            }
        }

        throw new IllegalArgumentException("The HomeMenu has not found.");
    }
}
