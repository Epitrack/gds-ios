package com.epitrack.guardioes.utility;

import android.content.Context;
import android.net.ConnectivityManager;

/**
 * @author Igor Morais
 */
public final class NetworkUtility {

    private static final String TAG = Utility.class.getSimpleName();

    private NetworkUtility() {

    }

    public static boolean isOnline(Context context) {
        boolean bReturn = false;
        try {
            ConnectivityManager cm = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
            if (cm.getActiveNetworkInfo() != null && cm.getActiveNetworkInfo().isAvailable() && cm.getActiveNetworkInfo().isConnected()) {
                bReturn = true;
            } else {
                bReturn = false;
            }
        } catch (Exception e) {
            bReturn = false;
        }
        return bReturn;
    }
}
