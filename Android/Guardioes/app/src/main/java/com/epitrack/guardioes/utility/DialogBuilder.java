package com.epitrack.guardioes.utility;

import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;

import com.afollestad.materialdialogs.MaterialDialog;
import com.epitrack.guardioes.R;

/**
 * @author Igor Morais
 */
public final class DialogBuilder extends BaseBuilder {

    public DialogBuilder(final Context context) {
        super(context);
    }

    public MaterialDialog.Builder load() {

        return new MaterialDialog.Builder(getContext())
                                 .backgroundColor(Color.rgb(30, 136, 229))
                                 .titleColorRes(R.color.white_dark)
                                 .contentColorRes(R.color.white_dark)
                                 .negativeColorRes(R.color.white_dark)
                                 .positiveColorRes(R.color.white_dark);
    }
}
