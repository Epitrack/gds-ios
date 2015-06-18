package com.epitrack.guardioes.view;

import android.app.DialogFragment;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;

public abstract class AbstractNotifyDialog extends DialogFragment implements OnClickListener {

    private static final String TAG = AbstractNotifyDialog.class.getSimpleName();

    private static final String TAG_NEGATIVE_ACTION = "negative_action";
    private static final String TAG_NEUTRAL_ACTION = "neutral_action";
    private static final String TAG_POSITIVE_ACTION = "positive_action";

    private int requestCode;

    private OnDialogListener listener;

    @Nullable
    @Override
    public View onCreateView(final LayoutInflater inflater, final ViewGroup viewGroup, final Bundle bundle) {

        final View view = inflater.inflate(getLayout(), viewGroup, false);

        findViews(view);

        return view;
    }

    private void findViews(final View view) {

        final View viewNegative = view.findViewWithTag(TAG_NEGATIVE_ACTION);

        if (viewNegative != null) {
            viewNegative.setOnClickListener(this);
        }

        final View viewNeutral = view.findViewWithTag(TAG_NEUTRAL_ACTION);

        if (viewNeutral != null) {
            viewNeutral.setOnClickListener(this);
        }

        final View viewPositive = view.findViewWithTag(TAG_POSITIVE_ACTION);

        if (viewPositive != null) {
            viewPositive.setOnClickListener(this);
        }
    }

    @Override
    public void onClick(final View view) {

        if (view.getTag().equals(TAG_POSITIVE_ACTION)) {
            getListener().onActionPositive(this, getRequestCode());

        } else if (view.getTag().equals(TAG_NEGATIVE_ACTION)) {
            getListener().onActionPositive(this, getRequestCode());

        } else if (view.getTag().equals(TAG_NEUTRAL_ACTION)) {
            getListener().onActionPositive(this, getRequestCode());
        }
    }

    public final int getRequestCode() {
        return requestCode;
    }

    public final void setRequestCode(final int requestCode) {
        this.requestCode = requestCode;
    }

    public final OnDialogListener getListener() {
        return listener;
    }

    public final void setListener(final OnDialogListener listener) {
        this.listener = listener;
    }

    public abstract int getLayout();
}
