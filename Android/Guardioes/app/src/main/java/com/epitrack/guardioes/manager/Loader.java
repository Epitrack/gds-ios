package com.epitrack.guardioes.manager;

import android.os.Handler;
import android.os.HandlerThread;

import com.epitrack.guardioes.utility.Logger;

/**
 * @author Igor Morais
 */
public final class Loader {

    private static final String TAG = Loader.class.getSimpleName();

    private Handler handler;

    private final HandlerThread handlerThread = new HandlerThread(TAG);

    private Loader() {

        handlerThread.start();

        Logger.logDebug(TAG, "Start");
    }

    private static class LazyLoader {
        private static final Loader INSTANCE = new Loader();
    }

    public static Loader with() {
        return LazyLoader.INSTANCE;
    }

    public final Handler getHandler() {

        if (handler == null) {
            handler = new Handler(handlerThread.getLooper());
        }

        return handler;
    }
}
