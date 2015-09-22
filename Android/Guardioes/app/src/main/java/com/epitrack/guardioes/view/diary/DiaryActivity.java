package com.epitrack.guardioes.view.diary;

import android.graphics.Color;
import android.graphics.Typeface;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.model.SingleUser;
import com.epitrack.guardioes.model.User;
import com.epitrack.guardioes.request.Method;
import com.epitrack.guardioes.request.Requester;
import com.epitrack.guardioes.request.SimpleRequester;
import com.epitrack.guardioes.view.base.BaseAppCompatActivity;
import com.epitrack.guardioes.view.survey.ParentListener;
import com.github.mikephil.charting.animation.Easing;
import com.github.mikephil.charting.charts.PieChart;
import com.github.mikephil.charting.data.Entry;
import com.github.mikephil.charting.data.PieData;
import com.github.mikephil.charting.data.PieDataSet;
import com.github.mikephil.charting.formatter.PercentFormatter;
import com.github.mikephil.charting.utils.ColorTemplate;
import com.prolificinteractive.materialcalendarview.CalendarDay;
import com.prolificinteractive.materialcalendarview.MaterialCalendarView;
import com.prolificinteractive.materialcalendarview.OnDateChangedListener;
import com.prolificinteractive.materialcalendarview.OnMonthChangedListener;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;

import butterknife.Bind;

/**
 * @author Igor Morais
 */
public class DiaryActivity extends BaseAppCompatActivity implements ParentListener, OnDateChangedListener, OnMonthChangedListener {

    @Bind(R.id.text_view_participation)
    TextView textViewParticipation;

    @Bind(R.id.text_view_good_percentage)
    TextView textViewGoodPercentage;

    @Bind(R.id.text_view_good_report)
    TextView textViewGoodReport;

    @Bind(R.id.text_view_bad_percentage)
    TextView textViewBadPercentage;

    @Bind(R.id.text_view_bad_report)
    TextView textViewBadReport;

    @Bind(R.id.text_view_day)
    TextView textViewDay;

    @Bind(R.id.text_view_date)
    TextView textViewDate;

    @Bind(R.id.text_view_symptom)
    TextView textViewSymptom;

    @Bind(R.id.recycler_view)
    RecyclerView recyclerView;

    @Bind(R.id.pie_chart_diary)
    PieChart pieChart;

    private double goodCount = 0;
    private double badCount = 0;
    private double totalCount = 0;
    private double goodPercent = 0;
    private double badPercent = 0;

    SingleUser singleUser = SingleUser.getInstance();

    private static final DateFormat FORMATTER = SimpleDateFormat.getDateInstance();

    @Bind(R.id.calendarView)
    MaterialCalendarView materialCalendarView;

    @Override
    protected void onCreate(final Bundle bundle) {
        super.onCreate(bundle);

        setContentView(R.layout.diary);

        recyclerView.setHasFixedSize(true);

        recyclerView.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.HORIZONTAL, false));

        final List<User> parentList = new ArrayList<>();

        SimpleRequester simpleRequester = new SimpleRequester();
        simpleRequester.setUrl(Requester.API_URL + "user/household/" + singleUser.getId());
        simpleRequester.setJsonObject(null);
        simpleRequester.setMethod(Method.GET);

        parentList.add(new User(R.drawable.image_avatar_small_8, singleUser.getNick(),
                singleUser.getEmail(), singleUser.getId(),
                singleUser.getDob(), singleUser.getRace(),
                singleUser.getGender()));

        try {
            String jsonStr = simpleRequester.execute(simpleRequester).get();

            JSONObject jsonObject = new JSONObject(jsonStr);

            if (jsonObject.get("error").toString() == "false") {

                JSONArray jsonArray = jsonObject.getJSONArray("data");

                if (jsonArray.length() > 0) {

                    JSONObject jsonObjectHousehold;

                    for (int i = 0; i < jsonArray.length(); i++) {

                        jsonObjectHousehold = jsonArray.getJSONObject(i);
                        parentList.add(new User(R.drawable.image_avatar_small_8, jsonObjectHousehold.get("nick").toString(),
                                /*jsonObjectHousehold.get("email").toString()*/"", jsonObjectHousehold.get("id").toString(),
                                jsonObjectHousehold.get("dob").toString(), jsonObjectHousehold.get("race").toString(),
                                jsonObjectHousehold.get("gender").toString()));
                    }
                }
            }

        } catch (InterruptedException e) {
            e.printStackTrace();
        } catch (ExecutionException e) {
            e.printStackTrace();
        } catch (JSONException e) {
            e.printStackTrace();
        }

        recyclerView.setAdapter(new MemberAdapter(getApplicationContext(), this, parentList));

        setupView();
    }

    private void setupView() {

        SimpleRequester simpleRequester = new SimpleRequester();
        simpleRequester.setUrl(Requester.API_URL + "user/survey/summary");
        simpleRequester.setJsonObject(null);
        simpleRequester.setMethod(Method.GET);

        String jsonStr = null;
        try {
            jsonStr = simpleRequester.execute(simpleRequester).get();

            JSONObject jsonObject = new JSONObject(jsonStr);
            JSONObject jsonObjectSympton = jsonObject.getJSONObject("data");

            goodCount = Integer.parseInt(jsonObjectSympton.get("no_symptom").toString());
            badCount = Integer.parseInt(jsonObjectSympton.get("symptom").toString());
            totalCount = Integer.parseInt(jsonObjectSympton.get("total").toString());

            textViewParticipation.setText((int)totalCount +  " Participações");

            goodPercent = goodCount / totalCount;
            textViewGoodPercentage.setText((int)(goodPercent * 100) + "% Bem");
            textViewGoodReport.setText((int) goodCount + " Relatórios");

            badPercent = badCount / totalCount;
            textViewBadPercentage.setText((int)(badPercent * 100) + "% Mal");
            textViewBadReport.setText((int) badCount + " Relatórios");

            //Pie Char Config
            pieChart.setUsePercentValues(false);
            pieChart.setDescription("");
            pieChart.setDrawCenterText(false);
            pieChart.setDrawSliceText(false);
            pieChart.setDrawHoleEnabled(false);
            pieChart.setHoleColorTransparent(false);
            pieChart.setHoleRadius(7);
            pieChart.setTransparentCircleRadius(10);
            pieChart.setRotationAngle(0);
            pieChart.setRotationEnabled(false);

            setData();

        } catch (InterruptedException e) {
            e.printStackTrace();
        } catch (ExecutionException e) {
            e.printStackTrace();
        } catch (JSONException e) {
            e.printStackTrace();
        }

        //Calendar Config
        materialCalendarView.setOnDateChangedListener(this);
        materialCalendarView.setOnMonthChangedListener(this);

        //textViewDay.setText("Sexta-feira");
        //textViewDate.setText("15 de maio");
        //textViewSymptom.setText("7 Sintomas");
    }

    @Override
    public void onParentSelect(String id) {

    }

    private void setData() {

        float[] yData = { (int)(badPercent * 100), (int)(goodPercent * 100)};
        String[] xData = { "Mal", "Bem" };

        ArrayList<Entry> yVals1 = new ArrayList<Entry>();

        for (int i = 0; i < yData.length; i++)
            yVals1.add(new Entry(yData[i], i));

        ArrayList<String> xVals = new ArrayList<String>();

        for (int i = 0; i < xData.length; i++)
            xVals.add(xData[i]);

        PieDataSet dataSet = new PieDataSet(yVals1, "");
        dataSet.setSliceSpace(2);
        dataSet.setSelectionShift(2);

        int colors[] = {Color.parseColor("#FF0000"),Color.parseColor("#CCCC00")};

        dataSet.setColors(colors);

        // instantiate pie data object now
        PieData data = new PieData(xVals, dataSet);
        //data.setValueFormatter(new PercentFormatter());
        //data.setValueTextSize(0f);
        //data.setValueTextColor(R.color.grey_dark);
        data.setDrawValues(false);
        data.setHighlightEnabled(false);

        pieChart.setData(data);
        pieChart.invalidate();
    }

    @Override
    public void onDateChanged(@NonNull MaterialCalendarView widget, @Nullable CalendarDay date) {
        if(date == null) {
            //textView.setText(null);
        }
        else {
            //textView.setText(FORMATTER.format(date.getDate()));
            Toast.makeText(this, FORMATTER.format(date.getDate()), Toast.LENGTH_SHORT).show();
        }
    }

    @Override
    public void onMonthChanged(MaterialCalendarView materialCalendarView, CalendarDay date) {
        Toast.makeText(this, FORMATTER.format(date.getDate()), Toast.LENGTH_SHORT).show();
    }
}
