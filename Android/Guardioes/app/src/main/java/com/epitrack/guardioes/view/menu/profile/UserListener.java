package com.epitrack.guardioes.view.menu.profile;

import com.epitrack.guardioes.model.User;

public interface UserListener {

    void onAdd();

    void onEdit(User user);

    void onDelete(User user);

    // TODO: We need to define the entity, this ia a stub only
}
