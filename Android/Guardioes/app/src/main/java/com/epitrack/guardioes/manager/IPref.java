package com.epitrack.guardioes.manager;

/**
 * @author Igor Morais
 */
public interface IPref {

    <T> T get(String key);

    <T> boolean put(String key, T entity);

    boolean remove(String key);
}
