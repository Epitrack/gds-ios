package com.epitrack.guardioes.view.menu.help;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.view.IMenu;

/**
 * @author Igor Morais
 */
public enum HelpContact implements IMenu {

    //MAIL        (1, R.string.mail, R.drawable.icon_mail),
    FACEBOOK    (2, R.string.facebook, R.drawable.icon_facebook),
    TWITTER     (3, R.string.twitter, R.drawable.icon_twitter),
    REPORT      (4, R.string.report, R.drawable.icon_report);

    private final int id;
    private final int name;
    private final int icon;

    HelpContact(final int id, final int name, final int icon) {
        this.id = id;
        this.name = name;
        this.icon = icon;
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

    public static HelpContact getBy(final int id) {

        for (final HelpContact help : HelpContact.values()) {

            if (help.getId() == id) {
                return help;
            }
        }

        throw new IllegalArgumentException("The HelpContact has not found.");
    }
}
