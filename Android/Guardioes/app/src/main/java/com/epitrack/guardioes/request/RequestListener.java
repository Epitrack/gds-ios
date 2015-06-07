package com.epitrack.guardioes.request;

public interface RequestListener<T> {

    void onStart();

    void onError(Error error);

    void onSuccess(T entity);
}
