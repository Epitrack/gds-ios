package com.epitrack.guardioes.manager;

import com.epitrack.guardioes.BuildConfig;
import com.github.mmin18.layoutcast.LayoutCast;

/**
 * @author Igor Morais
 */
public final class Application extends android.app.Application {

    @Override
    public void onCreate() {
        super.onCreate();

        if (BuildConfig.DEBUG) {
            LayoutCast.init(this);
        }
    }
}
