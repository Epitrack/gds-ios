package com.epitrack.guardioes.request;

import android.content.Context;

/**
 * @author Igor Morais
 */
class BaseRequester {

    private final Context context;

    public BaseRequester(final Context context) {
        this.context = context;
    }

    public final Context getContext() {
        return context;
    }
}
