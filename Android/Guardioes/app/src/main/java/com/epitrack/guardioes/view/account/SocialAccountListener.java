package com.epitrack.guardioes.view.account;

/**
 * @author Igor Morais
 */
public interface SocialAccountListener {

    void onError();

    void onCancel();

    void onSuccess();
}
