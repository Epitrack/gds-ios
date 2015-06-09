package com.epitrack.guardioes.manager;

import android.content.Context;

class BaseManager {

    private final Context context;

    public BaseManager(final Context context) {
        this.context = context;
    }

    public final Context getContext() {
        return context;
    }
}
