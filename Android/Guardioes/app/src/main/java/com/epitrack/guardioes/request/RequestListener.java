package com.epitrack.guardioes.request;

public interface RequestListener<T> {

    void onStart();

    void onError(Exception e);

    void onSuccess(T entity);
}
