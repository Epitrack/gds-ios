package com.epitrack.guardioes.manager;

import com.epitrack.guardioes.BuildConfig;
import com.epitrack.guardioes.utility.Constants;
import com.github.mmin18.layoutcast.LayoutCast;
import com.twitter.sdk.android.Twitter;
import com.twitter.sdk.android.core.TwitterAuthConfig;
import io.fabric.sdk.android.Fabric;

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
