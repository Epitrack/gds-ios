package com.epitrack.guardioes.view.survey;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.CheckBox;
import android.widget.TextView;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.model.Symptom;

public class SymptomAdapter extends ArrayAdapter<Symptom> {

    private static final int VIEW_TYPE_ITEM = 1;
    private static final int VIEW_TYPE_OTHER = 2;

    private static final int VIEW_TYPE_AMOUNT = 2;

    private static final int POSITION_VIEW_TYPE_OTHER = 11;

    private final Symptom[] symptomArray;

    public SymptomAdapter(final Context context, final Symptom[] symptomArray) {
        super(context, 0, symptomArray);

        this.symptomArray = symptomArray;
    }

    public static class ViewHolder {

        CheckBox checkBoxSymptom;
        TextView textViewName;
    }

    @Override
    public int getCount() {
        return symptomArray.length + 1;
    }

    @Override
    public int getViewTypeCount() {
        return VIEW_TYPE_AMOUNT;
    }

    @Override
    public int getItemViewType(final int position) {
        return (position == POSITION_VIEW_TYPE_OTHER ? VIEW_TYPE_OTHER : VIEW_TYPE_ITEM) - 1;
    }

    @Override
    public View getView(final int position, final View convertView, final ViewGroup viewGroup) {
        View view = convertView;

        if (getItemViewType(position) == VIEW_TYPE_OTHER) {

            return LayoutInflater.from(viewGroup.getContext())
                                 .inflate(R.layout.symptom_other, viewGroup, false);

        } else {

            ViewHolder viewHolder;

            if (view == null) {

                view = LayoutInflater.from(viewGroup.getContext())
                                     .inflate(R.layout.symptom_item, viewGroup, false);

                viewHolder = new ViewHolder();

                viewHolder.checkBoxSymptom = (CheckBox) view.findViewById(R.id.symptom_check_box);
                viewHolder.textViewName = (TextView) view.findViewById(R.id.symptom_text_view_name);

                view.setTag(viewHolder);

            } else {

                viewHolder = (ViewHolder) view.getTag();
            }

            final Symptom symptom = position > POSITION_VIEW_TYPE_OTHER ? getItem(position - 1) : getItem(position);

            viewHolder.textViewName.setText(symptom.getName());

            return view;
        }
    }
}
