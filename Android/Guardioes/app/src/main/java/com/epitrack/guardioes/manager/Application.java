package com.epitrack.guardioes.manager;

import com.epitrack.guardioes.BuildConfig;
import com.github.mmin18.layoutcast.LayoutCast;

public class Application extends android.app.Application {

    @Override
    public void onCreate() {
        super.onCreate();

        if (BuildConfig.DEBUG) {
            LayoutCast.init(this);
        }
    }
}
