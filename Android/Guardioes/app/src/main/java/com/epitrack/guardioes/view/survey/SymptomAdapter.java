package com.epitrack.guardioes.view.survey;

import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckBox;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.model.Symptom;

import butterknife.InjectView;

public class SymptomAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {

    private static final int POSITION_HEADER = 0;
    private static final int POSITION_OTHER = 8;

    private static final int VIEW_AMOUNT = 3;

    private final Symptom[] symptomArray;

    public SymptomAdapter(final Symptom[] symptomArray) {
        this.symptomArray = symptomArray;
    }

    public static class ViewType {

        public static final int ITEM = 1;
        public static final int HEADER = 2;
        public static final int FOOTER = 3;
        public static final int OTHER = 4;
    }

    public class HeaderViewHolder extends RecyclerView.ViewHolder {

        public HeaderViewHolder(final View view) {
            super(view);
        }
    }

    public class ItemViewHolder extends RecyclerView.ViewHolder {

        @InjectView(R.id.symptom_check_box_symptom)
        CheckBox checkBoxSymptom;

        public ItemViewHolder(final View view) {
            super(view);
        }
    }

    public class FooterViewHolder extends RecyclerView.ViewHolder {

        public FooterViewHolder(final View view) {
            super(view);
        }
    }

    public class OtherViewHolder extends RecyclerView.ViewHolder {

        public OtherViewHolder(final View view) {
            super(view);
        }
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(final ViewGroup viewGroup, final int viewType) {

        final LayoutInflater inflater = LayoutInflater.from(viewGroup.getContext());

        if (viewType == ViewType.ITEM) {

            final View view = inflater.inflate(R.layout.symptom_item, viewGroup, false);

            return new ItemViewHolder(view);

        } else if (viewType == ViewType.HEADER) {

            final View view = inflater.inflate(R.layout.symptom_header, viewGroup, false);

            return new HeaderViewHolder(view);

        } else if (viewType == ViewType.FOOTER) {

            final View view = inflater.inflate(R.layout.symptom_footer, viewGroup, false);

            return new FooterViewHolder(view);

        } else if (viewType == ViewType.OTHER) {

            final View view = inflater.inflate(R.layout.symptom_other, viewGroup, false);

            return new OtherViewHolder(view);
        }

        throw new IllegalArgumentException("The ViewHolder has not found.");
    }

    @Override
    public void onBindViewHolder(final RecyclerView.ViewHolder viewHolder, final int position) {

        if (viewHolder instanceof ItemViewHolder) {

            ((ItemViewHolder) viewHolder).checkBoxSymptom.setText(getItem(position).getName());
        }
    }

    @Override
    public int getItemViewType(final int position) {

        if (position == POSITION_HEADER) {
            return ViewType.HEADER;

        } else if (position == getItemCount() - 1) {
            return ViewType.FOOTER;

        } else if (position == POSITION_OTHER) {
            return ViewType.OTHER;

        } else {
            return ViewType.ITEM;
        }
    }

    @Override
    public int getItemCount() {
        return symptomArray.length + VIEW_AMOUNT;
    }

    public Symptom getItem(final int position) {

        if (position > POSITION_OTHER) {
            return symptomArray[position - 2];
        }

        return symptomArray[position - 1];
    }
}
