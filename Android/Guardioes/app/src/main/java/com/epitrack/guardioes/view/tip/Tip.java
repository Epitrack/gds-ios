package com.epitrack.guardioes.view.tip;

import android.app.Activity;
import android.app.DialogFragment;
import android.app.Fragment;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.view.IMenu;
import com.epitrack.guardioes.view.MapPointActivity;

/**
 * @author Igor Morais
 */
public enum Tip implements IMenu {

    HOSPITAL        (1, R.string.hospital, R.drawable.icon_hospital, MapPointActivity.class),
    VACCINE         (2, R.string.vaccine, R.drawable.icon_vaccine, VaccineActivity.class),
    TELEPHONE       (3, R.string.phone, R.drawable.icon_phone, Fragment.class), // TODO: Stub
    PHARMACY        (4, R.string.pharmacy, R.drawable.icon_pharmacy, MapPointActivity.class),
    CARE            (5, R.string.care, R.drawable.icon_care, CareActivity.class),
    PREVENTION      (6, R.string.prevention, R.drawable.icon_prevention, PreventionActivity.class);

    private final int id;
    private final int name;
    private final int icon;
    private final Class<?> menuClass;

    Tip(final int id, final int name, final int icon, final Class<?> menuClass) {

        this.id = id;
        this.name = name;
        this.icon = icon;
        this.menuClass = menuClass;
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

    public static Tip getBy(final long id) {

        for (final Tip tip : Tip.values()) {

            if (tip.getId() == id) {
                return tip;
            }
        }

        throw new IllegalArgumentException("The Tip has not found.");
    }
}
