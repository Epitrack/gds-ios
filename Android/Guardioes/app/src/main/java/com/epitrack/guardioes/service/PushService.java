package com.epitrack.guardioes.service;

import android.os.Bundle;

import com.google.android.gms.gcm.GcmListenerService;

/**
 * @author Igor Morais
 */
public class PushService extends GcmListenerService {

    @Override
    public void onMessageReceived(final String from, final Bundle bundle) {
        super.onMessageReceived(from, bundle);

        // TODO: Send notification
    }
}
