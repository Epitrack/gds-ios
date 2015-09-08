package com.epitrack.guardioes.view.base;

import com.epitrack.guardioes.view.NotifyDialog;

/**
 * @author Igor Morais
 */
public interface DialogListener {

    void onActionNegative(NotifyDialog dialog, int requestCode);

    void onActionNeutral(NotifyDialog dialog, int requestCode);

    void onActionPositive(NotifyDialog dialog, int requestCode);
}
