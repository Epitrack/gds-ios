package com.epitrack.guardioes.view;

public interface DialogListener {

    void onActionNegative(AbstractNotifyDialog dialog, int requestCode);

    void onActionNeutral(AbstractNotifyDialog dialog, int requestCode);

    void onActionPositive(AbstractNotifyDialog dialog, int requestCode);
}
