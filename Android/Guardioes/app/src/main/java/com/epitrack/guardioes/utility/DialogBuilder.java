package com.epitrack.guardioes.utility;

import android.content.Context;

import com.afollestad.materialdialogs.MaterialDialog;
import com.epitrack.guardioes.R;

public final class DialogBuilder extends BaseBuilder {

    public DialogBuilder(final Context context) {
        super(context);
    }

    public MaterialDialog.Builder load() {

        return new MaterialDialog.Builder(getContext())
                                 .titleColorRes(android.R.color.black)
                                 .contentColorRes(R.color.translucent_black_dark)
                                 .negativeColorRes(R.color.blue_bright)
                                 .positiveColorRes(R.color.blue_bright);
    }
}
