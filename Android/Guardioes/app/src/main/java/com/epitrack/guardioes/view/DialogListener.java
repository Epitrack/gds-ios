package com.epitrack.guardioes.view;

public interface DialogListener {

    void onActionNegative(NotifyDialog dialog, int requestCode);

    void onActionNeutral(NotifyDialog dialog, int requestCode);

    void onActionPositive(NotifyDialog dialog, int requestCode);
}
