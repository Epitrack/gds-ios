package com.epitrack.guardioes.request;

import java.util.Map;

public interface IRequester {

    <T> void request(final Method method,
                     final String url,
                     final RequestListener<T> listener);

    <T> void request(final Method method,
                     final String url,
                     final Map<String, String> headerMap,
                     final RequestListener<T> listener);

    <T> void request(final Method method,
                     final String url,
                     final Map<String, String> paramMap,
                     final Map<String, String> headerMap,
                     final RequestListener<T> listener);

    <E, T> void request(final Method method,
                        final String url,
                        final Map<String, String> headerMap,
                        final E body,
                        final RequestListener<T> listener);

    <T> void request(final Method method,
                     final String url,
                     final Map<String, String> queryMap,
                     final Map<String, String> headerMap,
                     final Map<String, String> bodyMap,
                     final RequestListener<T> listener);

    <E, T> void request(final Method method,
                        final String url,
                        final Map<String, String> queryMap,
                        final Map<String, String> headerMap,
                        final E body,
                        final RequestListener<T> listener);
}
